extends TextureButton

@export var audio_stream_name: String
@export var texture_not_muted: Texture2D
@export var texture_muted: Texture2D

func _process(delta: float) -> void:
	var bus_index := AudioServer.get_bus_index(audio_stream_name)
	var muted := AudioServer.is_bus_mute(bus_index)
	
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
		if AudioServer.is_bus_mute(bus_index):
			AudioServer.set_bus_mute(bus_index, false)
			update_icon(false)
		else:
			AudioServer.set_bus_mute(bus_index, true)
			update_icon(true)
