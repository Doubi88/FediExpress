extends SpinBox

func _ready() -> void:
	value = GlobalServerData.goal_deliveries


func _on_value_changed(value: float) -> void:
	GlobalServerData.goal_deliveries = value
