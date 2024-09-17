extends Node2D

class_name Navigation

@export var start: Node2D
@export var goals: Array[Node2D] = []
@export var color: Color

func _draw():
	if start != null:
		for goal in goals:
			draw_line(start.global_position, goal.global_position, color, 10, true)

func _process(delta: float) -> void:
	queue_redraw()
