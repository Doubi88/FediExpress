extends AudioStreamPlayer

@onready var tracks: Array[AudioStream] = [
	#preload("res://Audio/Music/just-relax-11157.mp3"),
	#preload("res://Audio/Music/my-life-main-6670.mp3"),
	#preload("res://Audio/Music/coniferous-forest-142569.mp3"),
	#preload("res://Audio/Music/forest-lullaby-110624.mp3"),
	#preload("res://Audio/Music/leva-eternity-149473.mp3"),
	#preload("res://Audio/Music/summer-walk-152722.mp3")
]

var current := -1

func _ready() -> void:
	tracks.shuffle()
	finished.connect(play_next)
	play_next()

func play_next() -> void:
	if (tracks.size() > 0):
		current = (current + 1) % tracks.size()
		stream = tracks[current]
		play()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("next_track"):
		stop()
		play_next()
