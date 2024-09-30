extends CanvasLayer

@onready var label: RichTextLabel = $MarginContainer/HBoxContainer/RichTextLabel
@onready var button = $MarginContainer/HBoxContainer/NextButton
@onready var name_label = $MarginContainer/HBoxContainer/VBoxContainer/Label

@export var text_pages_array: Array[String]:
	set(value):
		text_pages_array = value
		update_view()
	get:
		return text_pages_array

@export var speaker_name: String:
	set(value):
		speaker_name = value
		update_view()
	get:
		return speaker_name


@export var current_page := 0:
	set(value):
		current_page = value
		update_view()
	get():
		return current_page

func _ready() -> void:
	update_view()
	GlobalServerData.game_over_now.connect(hide)
	SceneSwitcher.resetting_game.connect(hide)

func update_view() -> void:
	if label != null and text_pages_array != null and current_page < text_pages_array.size():
		label.text = text_pages_array[current_page]
	
	if button != null:
		if current_page + 1 >= text_pages_array.size():
			button.text = '[Q]\n\nX'
		else:
			button.text = '[Q]\n\n>'
	
	if name_label != null:
		if speaker_name != null:
			name_label.text = speaker_name
			name_label.show()
		else:
			name_label.hide()


func _on_next_button_pressed() -> void:
	if current_page + 1 >= text_pages_array.size():
		hide()
	else:
		current_page += 1

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("dialogue next"):
		_on_next_button_pressed()
