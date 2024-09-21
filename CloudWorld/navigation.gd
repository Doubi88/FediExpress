extends Node2D

class_name Navigation

@export var start: Node2D
@export var goals: Array[Node2D] = []
@export var color: Color
@export var width: int
@export var distance: int
@export var length: int


func _draw():
	if start != null:
		for goal in goals:
			var vector = (goal.global_position - start.global_position).normalized()
			var startP = vector * distance
			var endP = vector * length
			var point1 = start.global_position + startP
			var point2 = start.global_position + startP + endP
			draw_polyline([point1, point2], color, 3)
			

func _process(delta: float) -> void:
	queue_redraw()
