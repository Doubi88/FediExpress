extends AStarGrid2D

class_name AStarGrid2DRandomWeight

var costs: Dictionary = {}

var rand: RandomNumberGenerator;

func _init(rand: RandomNumberGenerator):
	self.rand = rand

func _compute_cost(from_id: Vector2i, to_id: Vector2i) -> float:
	var key: PackedVector2Array = [from_id, to_id]
	var result: float = 0
	if costs.has(key):
		result = costs[key];
	else:
		result = rand.randf()
		costs[key] = result
	return result
	
func _estimate_cost(from_id: Vector2i, to_id: Vector2i):
	return _compute_cost(from_id, to_id)
