extends StaticBody2D

class_name FediAccountHouse

@onready var mission_window_packed = preload("res://UI/MissionsWindow.tscn")
@onready var attention_icon = $Attention
@onready var name_label = $NameLabel
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var thank_you_audios: Array[AudioStream] = [
	preload("res://Audio/thank_you1.ogg"),
	preload("res://Audio/thank_you2.ogg")
]

@export var account_data: FediAccountData:
	set(value):
		account_data = value
		if value != null and is_node_ready():
			missions_updated()
	get:
		return account_data

func _ready() -> void:
	GlobalServerData.new_mission.connect(new_mission)
	GlobalServerData.mission_accepted.connect(mission_accepted)
	GlobalServerData.mission_delivered.connect(mission_delivered)
	GlobalServerData.mission_failed.connect(mission_failed)
	if account_data != null:
		missions_updated()
	
func _process(delta: float) -> void:
	if account_data != null:
		name_label.text = account_data.account_name
	else:
		name_label.text = ""
	
func new_mission(mission: Mission) -> void:
	missions_updated()

func mission_accepted(mission: Mission) -> void:
	if mission.from == account_data:
		audio_player.stream = thank_you_audios.pick_random()
		audio_player.play()
	missions_updated()

func mission_delivered(mission: Mission) -> void:
	if mission.to == account_data:
		audio_player.stream = thank_you_audios.pick_random()
		audio_player.play()
	missions_updated()

func mission_failed(mission: Mission) -> void:
	missions_updated()

func missions_updated():
	if GlobalServerData.has_mission_from_account(account_data):
		attention_icon.visible = true
	else:
		attention_icon.visible = false
