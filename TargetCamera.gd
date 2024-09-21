extends Camera2D

class_name TargetCamera

@export var target: Node2D
@export var lerp_weight: float = 0.1

func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.lerp(target.global_position, lerp_weight)
