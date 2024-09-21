extends Window

class_name DialogueWindow

@onready var label: RichTextLabel = $HBoxContainer/RichTextLabel

@export var text: String:
	set(value):
		text = value
		if label != null:
			label.text = text
	get:
		return label.text

func _ready() -> void:
	if text != null:
		label.text = text
		
func get_label() -> RichTextLabel:
	return label
