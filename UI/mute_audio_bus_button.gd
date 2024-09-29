extends TextureButton

@export var audio_stream_name: String
@export var texture_not_muted: Texture2D
@export var texture_muted: Texture2D

func _process(delta: float) -> void:
	var bus_index := AudioServer.get_bus_index(audio_stream_name)
	var muted := AudioServer.is_bus_mute(bus_index) or (db_to_linear(AudioServer.get_bus_volume_db(bus_index)) == 0)
	
	if (muted and texture_normal != texture_muted) or (not muted and texture_normal != texture_not_muted):
		update_icon(muted)
	
func update_icon(muted: bool) -> void:
	if muted:
		if texture_muted != null:
			texture_normal = texture_muted
	else:
		if texture_not_muted != null:
			texture_normal = texture_not_muted

func _on_pressed() -> void:
	if audio_stream_name != null:
		var bus_index := AudioServer.get_bus_index(audio_stream_name)
		var is_mute = AudioServer.is_bus_mute(bus_index)
		var volume = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
		if (is_mute) or (volume == 0):
			AudioServer.set_bus_mute(bus_index, false)
			if volume == 0:
				AudioServer.set_bus_volume_db(bus_index, linear_to_db(0.3))
				AudioSignals.volume_changed.emit(audio_stream_name, 0.3)
			update_icon(false)
		else:
			AudioServer.set_bus_mute(bus_index, true)
			update_icon(true)
