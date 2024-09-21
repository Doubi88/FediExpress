extends Node2D

class_name Navigation

@export var start: Node2D
@export var goals: Array[Node2D] = []
@export var color: Color
@export var distance := 50

func _draw():
	if start != null:
		for goal in goals:
			var vector = (goal.global_position - start.global_position).normalized()
			var center = vector * distance
			var point1 = center + Vector2(25, -25)
			var point3 = center + Vector2(-25, 25)
			draw_polyline([point1, center, point3], color, 2)
			

func _process(delta: float) -> void:
	queue_redraw()
