extends Node

enum Difficulty {
	COZY, EASY, MEDIUM, HARD
}

signal game_over_now()

var server_data: Array[FediServerData]
var new_mission_interval_range = [5, 10] # Seconds
var available_missions: Array[Mission]
var accepted_missions: Array[Mission]
var failed_missions: Array[Mission]

@export var mission_expiration_seconds: int = 10 * 60
@export var difficulty: Difficulty = Difficulty.EASY:
	set(value):
		difficulty = value
		match difficulty:
			Difficulty.COZY:
				mission_expiration_seconds = 0
			Difficulty.EASY:
				mission_expiration_seconds = 8 * 60
			Difficulty.MEDIUM:
				mission_expiration_seconds = 5 * 60
			Difficulty.HARD:
				mission_expiration_seconds = 2 * 60
	get:
		return difficulty

@export var goal_deliveries := 10
@export var max_failures := 5
@export var time_limit_seconds := 600.0
var remaining_time: float
var timer_started: bool = false

var points: int = 0

var elapsed_since_last_create_mission: float = 0
var next_mission_time: int = 0

signal new_mission(mission: Mission)
signal mission_accepted(mission: Mission);
signal mission_delivered(mission: Mission);
signal mission_failed(mission: Mission);

func get_difficulty_name() -> String:
	Time.get_unix_time_from_system()
	var result: String = ''
	match difficulty:
		Difficulty.COZY:
			result = "Cozy"
		Difficulty.EASY:
			result = "Easy"
		Difficulty.MEDIUM:
			result = "Medium"
		Difficulty.HARD:
			result = "Hard"
	return result

func update_timer(delta: float) -> void:
	if timer_started and time_limit_seconds > 0:
		remaining_time -= delta

func start_timer():
	remaining_time = time_limit_seconds
	timer_started = true
	
func is_game_over() -> bool:
	var result := false
	if timer_started:
		if (time_limit_seconds > 0 and remaining_time <= 0) or \
			(goal_deliveries > 0 and points >= goal_deliveries) or \
			(max_failures > 0 and failed_missions.size() >= max_failures):
			result = true
	return result
		
func _process(delta: float) -> void:
	update_timer(delta)
	if server_data.size() > 0:
		elapsed_since_last_create_mission += delta
		if next_mission_time == 0:
			next_mission_time = randi_range(new_mission_interval_range[0], new_mission_interval_range[1])
		if elapsed_since_last_create_mission >= next_mission_time:
			var mission: Mission = Mission.new()
			mission.from = server_data.pick_random().accounts.pick_random()
			while mission.to == null or mission.to == mission.from:
				mission.to = server_data.pick_random().accounts.pick_random()
			
			mission.creation_second = Time.get_unix_time_from_system()

			if mission_expiration_seconds > 0:
				var timer: Timer = Timer.new()
				add_child(timer)
				timer.timeout.connect(func(): fail_mission(mission))
				timer.start(mission_expiration_seconds)

			available_missions.append(mission)
			
			next_mission_time = randi_range(new_mission_interval_range[0], new_mission_interval_range[1])
			elapsed_since_last_create_mission = 0
			new_mission.emit(mission)
	if is_game_over():
		game_over()

func game_over():
	timer_started = false
	get_tree().paused = true
	game_over_now.emit()

func reset() -> void:
	timer_started = false
	points = 0
	failed_missions.clear()
	accepted_missions.clear()
	available_missions.clear()
	server_data.clear()
	
func accept_mission(mission: Mission) -> void:
	var index = available_missions.find(mission)
	if index >= 0:
		var use = available_missions.pop_at(index)
		accepted_missions.append(use)
		mission_accepted.emit(use)

func deliver_mission(mission: Mission, account: FediAccountData) -> bool:
	var index = accepted_missions.find(mission)
	var result = false
	if index >= 0 and mission.to == account:
		accepted_missions.remove_at(index)
		points += 1
		result = true
		mission_delivered.emit(mission)
	return result

func fail_mission(mission: Mission):
	var index = accepted_missions.find(mission)
	accepted_missions.remove_at(index)
	failed_missions.append(mission)
	mission_failed.emit(mission)

func has_mission_from_account(account: FediAccountData) -> bool:
	var result := false
	var index := 0
	while index < available_missions.size() and (!result):
		if available_missions[index].from.account_name == account.account_name and available_missions[index].from.fedi_server.server_name == account.fedi_server.server_name:
			result = true
		index += 1
	return result

func has_mission_from_server(server_name: String) -> bool:
	var result := false
	var index := 0
	while index < available_missions.size() and (!result):
		if available_missions[index].from.fedi_server.server_name == server_name:
			result = true
		index += 1
	return result
