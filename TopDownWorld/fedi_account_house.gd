extends StaticBody2D

class_name FediAccountHouse

@onready var mission_window_packed = preload("res://UI/MissionsWindow.tscn")
@onready var attention_icon = $Attention
@onready var name_label = $NameLabel

@export var account_data: FediAccountData:
	set(value):
		account_data = value
		if value != null and is_node_ready():
			missions_updated()
	get:
		return account_data

func _ready() -> void:
	GlobalServerData.missions_updated.connect(missions_updated)
	if account_data != null:
		missions_updated()
	
func _process(delta: float) -> void:
	if account_data != null:
		name_label.text = account_data.account_name
	else:
		name_label.text = ""
	
func missions_updated():
	if GlobalServerData.has_mission_from_account(account_data):
		attention_icon.visible = true
	else:
		attention_icon.visible = false
