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
	update_missions(null)
	GlobalServerData.new_mission.connect(update_missions)
	GlobalServerData.mission_accepted.connect(update_missions)
	GlobalServerData.mission_delivered.connect(update_missions)
	GlobalServerData.mission_failed.connect(update_missions)

func _process(_delta: float) -> void:
	update_mission_timers()

func update_caption() -> void:
	if account != null and captionLabel != null:
		captionLabel.text = 'Missions from ' + account.account_name + '@' + account.fedi_server.server_name
	
func update_mission_timers():
	for index in range(available.item_count):
		var mission: Mission = available.get_item_metadata(index)
		var text: String = generate_item_text(mission)
		available.set_item_text(index, text)

	for index in range(accepted.item_count):
		var mission: Mission = accepted.get_item_metadata(index)
		var text: String = generate_item_text(mission)
		accepted.set_item_text(index, text)

func generate_item_text(mission: Mission) -> String:
	var mission_time_text := ""
	if GlobalServerData.mission_expiration_seconds > 0:
		var mission_time: float = GlobalServerData.mission_expiration_seconds - (Time.get_unix_time_from_system() - mission.creation_second)
		var mission_time_dict: Dictionary = Time.get_time_dict_from_unix_time(round(mission_time) as int)
		mission_time_text = ' ' + String.num(mission_time_dict.minute) + ":" + String.num(mission_time_dict.second)
	return mission.to.account_name + '@' + mission.to.fedi_server.server_name + mission_time_text

func update_missions(_updated_mission: Mission):
	var index: int = 0
	for mission in GlobalServerData.available_missions:
		if mission.from == account:
			var text: String = generate_item_text(mission)
			if available.item_count < (index + 1):
				available.add_item(text)
			else:
				available.set_item_text(index, text)
			available.set_item_metadata(index, mission)
			index += 1
	if available.item_count > index:
		available.item_count = index
	
	index = 0
	for mission in GlobalServerData.accepted_missions:
		var text: String = generate_item_text(mission)
		if (accepted.item_count < index + 1):
			accepted.add_item(text)
		else:
			accepted.set_item_text(index, text)
			
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

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventKey):
		if event.is_action_pressed("toggle engine"):
			close_requested.emit()
