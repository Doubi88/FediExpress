extends Node2D

@export var next_scene: PackedScene
@export var wait_sec_on_end := 1
@onready var sprite := $AnimatedSprite2D

func _ready() -> void:
	sprite.animation_finished.connect(animation_finished)
	sprite.play()

func animation_finished():
	$Buttons.visible = true

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)
