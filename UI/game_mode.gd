extends Resource

class_name GameMode

@export var time_limit: float = 0
@export var goal: int = 0
@export var max_failed: int = 0

func _init(time_limit: float, goal: int, max_failed: int) -> void:
	self.time_limit = time_limit
	self.goal = goal
	self.max_failed = max_failed
