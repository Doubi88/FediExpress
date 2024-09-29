extends CanvasLayer

@onready var label: RichTextLabel = $MarginContainer/HBoxContainer/RichTextLabel
@onready var button = $MarginContainer/HBoxContainer/NextButton
@onready var name_label = $MarginContainer/HBoxContainer/VBoxContainer/Label

@export var current_page := 0:
	set(value):
		current_page = value
		update_view()
	get():
		return current_page

@export var text_pages: Array[String]:
	set(value):
		text_pages = value
		update_view()
	get:
		return text_pages

@export var speaker_name: String:
	set(value):
		speaker_name = value
		update_view()
	get:
		return speaker_name

func _ready() -> void:
	update_view()

func update_view() -> void:
	if label != null and text_pages != null and current_page < text_pages.size():
		label.text = text_pages[current_page]
	if current_page + 1 >= text_pages.size():
		button.text = 'X'
	else:
		button.text = '>'
	if speaker_name != null:
		name_label.text = speaker_name
		name_label.show()
	else:
		name_label.hide()


func _on_next_button_pressed() -> void:
	if current_page + 1 >= text_pages.size():
		hide()
	else:
		current_page += 1
