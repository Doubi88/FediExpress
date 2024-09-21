extends Node2D

@export var next_scene: PackedScene
@export var wait_sec_on_end := 1
@onready var sprite := $AnimatedSprite2D
func _ready() -> void:
	sprite.animation_finished.connect(animation_finished)
	sprite.play()

func animation_finished():
	if next_scene != null:
		var timer := Timer.new()
		timer.timeout.connect(func(): get_tree().change_scene_to_packed(next_scene))
		timer.wait_time = wait_sec_on_end
		add_child(timer)
		timer.start()
