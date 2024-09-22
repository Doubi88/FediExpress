extends Node2D

@export var next_scene: PackedScene
@export var wait_sec_on_end := 1
@onready var sprite := $AnimatedSprite2D
@onready var sfx_button_sprite = $Buttons/MuteSFXButton/AnimatedSprite2D
@onready var music_button_sprite = $Buttons/MuteMusicButton/AnimatedSprite2D

func _ready() -> void:
	sprite.animation_finished.connect(animation_finished)
	sprite.play()

func animation_finished():
	$Buttons.visible = true

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)


func _on_mute_music_button_pressed() -> void:
	var bus_index := AudioServer.get_bus_index("Music")
	if AudioServer.is_bus_mute(bus_index):
		AudioServer.set_bus_mute(bus_index, false)
		music_button_sprite.frame = 0
	else:
		AudioServer.set_bus_mute(bus_index, true)
		music_button_sprite.frame = 1



func _on_mute_sfx_button_pressed() -> void:
	var bus_index := AudioServer.get_bus_index("SFX")
	if AudioServer.is_bus_mute(bus_index):
		AudioServer.set_bus_mute(bus_index, false)
		sfx_button_sprite.frame = 0
	else:
		AudioServer.set_bus_mute(bus_index, true)
		sfx_button_sprite.frame = 1
