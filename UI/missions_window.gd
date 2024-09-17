extends Window

class_name MissionWindow

@export var account: FediAccountData:
	set(value):
		account = value
		update_caption()
	get:
		return account

@onready var available: ItemList = $VBoxContainer/AvailableMissionsList
@onready var accepted: ItemList = $VBoxContainer/AcceptedMissionsList
@onready var captionLabel: Label = $VBoxContainer/Caption

func _ready() -> void:
	update_caption()
	update_missions()
	GlobalServerData.missions_updated.connect(update_missions)

func _exit_tree() -> void:
	GlobalServerData.missions_updated.disconnect(update_missions)

func update_caption() -> void:
	if account != null and captionLabel != null:
		captionLabel.text = 'Missions from ' + account.account_name + '@' + account.fedi_server.server_name
	
func update_missions():
	var index: int = 0
	for mission in GlobalServerData.available_missions:
		if mission.from == account:
			if available.item_count < (index + 1):
				available.add_item(mission.to.account_name + '@' + mission.to.fedi_server.server_name)
			else:
				available.set_item_text(index, mission.to.account_name + '@' + mission.to.fedi_server.server_name)
			available.set_item_metadata(index, mission)
			index += 1
	if available.item_count > index:
		available.item_count = index
	
	index = 0
	for mission in GlobalServerData.accepted_missions:
		if (accepted.item_count < index + 1):
			accepted.add_item(mission.to.account_name + '@' + mission.to.fedi_server.server_name)
		else:
			accepted.set_item_text(index, mission.to.account_name + '@' + mission.to.fedi_server.server_name)
			
		accepted.set_item_metadata(index, mission)
		accepted.set_item_disabled(index, mission.to != account)
		index += 1
	if accepted.item_count > index:
		accepted.item_count = index

func _on_accept_button_pressed() -> void:
	for item: int in available.get_selected_items():
		var mission = available.get_item_metadata(item)
		GlobalServerData.accept_mission(mission)

func _on_deliver_button_pressed() -> void:
	for item: int in accepted.get_selected_items():
		var mission = accepted.get_item_metadata(item)
		GlobalServerData.deliver_mission(mission, account)
