extends StaticBody2D

class_name FediAccountHouse

@export var account_data: FediAccountData
@onready var name_label = $NameLabel

var player_inside: TopDownPlayer

func _process(delta: float) -> void:
	if account_data != null:
		name_label.text = account_data.account_name + '@' + account_data.fedi_server.server_name
	else:
		name_label.text = ""

	if player_inside != null and Input.is_action_just_pressed("toggle engine"):
		accept_mission()
		deliver_mission()
	
func accept_mission():
	var mission_index: int = find_mission(GlobalServerData.available_missions, false)
	if mission_index >= 0:
		var mission = GlobalServerData.available_missions.pop_at(mission_index)
		GlobalServerData.accepted_missions.append(mission)
		print("Accepted " + mission.from.account_name + " to " + mission.to.account_name + "@" + mission.to.fedi_server.server_name)

func deliver_mission():
	var mission_index: int = find_mission(GlobalServerData.accepted_missions, true)
	if mission_index >= 0:
		var mission = GlobalServerData.accepted_missions.pop_at(mission_index)
		print("Delivered " + mission.from.account_name + " to " + mission.to.account_name + "@" + mission.to.fedi_server.server_name)

func find_mission(array: Array[Mission], to: bool) -> int:
	var result: int = -1
	var mission_index: int = 0
	while result < 0 and mission_index < array.size():
		if ((not to) and array[mission_index].from == account_data) \
				or (to and array[mission_index].to == account_data):
			result = mission_index
		mission_index += 1
	
	return result


func _on_delivery_area_body_entered(body):
	if body is TopDownPlayer:
		player_inside = body


func _on_delivery_area_body_exited(body:Node2D) -> void:
	if body == player_inside:
		player_inside = null
