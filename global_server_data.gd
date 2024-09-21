extends Node

var server_data: Array[FediServerData]
var new_mission_interval_range = [5, 10] # Seconds
var available_missions: Array[Mission]
var accepted_missions: Array[Mission]

var points: int = 0

var elapsed_since_last_create_mission: float = 0
var next_mission_time: int = 0

signal missions_updated();

func _process(delta: float) -> void:
	if server_data.size() > 0:
		elapsed_since_last_create_mission += delta
		if next_mission_time == 0:
			next_mission_time = randi_range(new_mission_interval_range[0], new_mission_interval_range[1])
		if elapsed_since_last_create_mission >= next_mission_time:
			var mission = Mission.new()
			mission.from = server_data.pick_random().accounts.pick_random()
			while mission.to == null or mission.to == mission.from:
				mission.to = server_data.pick_random().accounts.pick_random()
				
			available_missions.append(mission)
			
			next_mission_time = randi_range(new_mission_interval_range[0], new_mission_interval_range[1])
			elapsed_since_last_create_mission = 0
			print("New mission:", mission.from.account_name + '@' + mission.from.fedi_server.server_name, " to ", mission.to.account_name + '@' +  mission.to.fedi_server.server_name)
			missions_updated.emit()
		
func accept_mission(mission: Mission) -> void:
	var index = available_missions.find(mission)
	if index >= 0:
		var use = available_missions.pop_at(index)
		accepted_missions.append(use)
		missions_updated.emit()

func deliver_mission(mission: Mission, account: FediAccountData) -> bool:
	var index = accepted_missions.find(mission)
	var result = false
	if index >= 0 and mission.to == account:
		accepted_missions.remove_at(index)
		points += 1
		result = true
		missions_updated.emit()
	return result

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
