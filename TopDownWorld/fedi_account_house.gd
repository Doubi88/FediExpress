extends StaticBody2D

class_name FediAccountHouse

@onready var mission_window_packed = preload("res://UI/MissionsWindow.tscn")

@export var account_data: FediAccountData
@onready var name_label = $NameLabel

func _process(delta: float) -> void:
	if account_data != null:
		name_label.text = account_data.account_name + '@' + account_data.fedi_server.server_name
	else:
		name_label.text = ""
	
