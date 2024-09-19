extends Camera2D

class_name TargetCamera

@export var target: Node2D
@export_range(0, 1) var lerp_weight: float = 0.4

func _process(delta):
	if target != null:
		global_position = global_position.lerp(target.global_position, lerp_weight)
