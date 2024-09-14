extends Node

var server_data: Array[FediServerData]
var new_mission_interval_range = [5, 10] # Seconds
var available_missions: Array[Mission]
var accepted_missions: Array[Mission]

var elapsed_since_last_create_mission: float = 0
var next_mission_time: int = 0

func _process(delta: float) -> void:
	elapsed_since_last_create_mission += delta
	if next_mission_time == 0:
		next_mission_time = randi_range(new_mission_interval_range[0], new_mission_interval_range[1])
	if elapsed_since_last_create_mission >= next_mission_time:
		var mission = Mission.new()
		mission.from = server_data.pick_random().accounts.pick_random()
		mission.to = server_data.pick_random().accounts.pick_random()
		available_missions.append(mission)
		
		next_mission_time = randi_range(new_mission_interval_range[0], new_mission_interval_range[1])
		elapsed_since_last_create_mission = 0
		print("New mission:", mission.from.account_name + '@' + mission.from.fedi_server.server_name, " to ", mission.to.account_name + '@' +  mission.to.fedi_server.server_name)
