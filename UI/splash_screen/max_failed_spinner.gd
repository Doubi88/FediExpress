extends SpinBox


func _ready() -> void:
	value = GlobalServerData.max_failures

func _on_value_changed(value: float) -> void:
	GlobalServerData.max_failures = value
