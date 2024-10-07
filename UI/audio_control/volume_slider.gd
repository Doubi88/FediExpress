extends HSlider

class_name VolumeSlider

@export var audio_bus_name: String

func _ready() -> void:
	update_value()
	AudioSignals.volume_changed.connect(func(bus_name: String, new_value: float):
		if bus_name == audio_bus_name:
			value = new_value
	)
	
func update_value() -> void:
	if audio_bus_name != null:
		var bus_index: int = AudioServer.get_bus_index(audio_bus_name)
		if bus_index >= 0:
			var volume_db = AudioServer.get_bus_volume_db(bus_index)
			value = db_to_linear(volume_db)

func _on_value_changed(value:float) -> void:
	if audio_bus_name != null:
		var bus_index: int = AudioServer.get_bus_index(audio_bus_name)
		if bus_index >= 0:
			AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
			AudioSignals.volume_changed.emit(audio_bus_name, value)
	
