extends CanvasLayer

func _ready() -> void:
	SceneSwitcher.resetting_game.connect(func(): hide())
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true


func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false


func _on_restart_button_pressed() -> void:
	var dialog: ConfirmationDialog = ConfirmationDialog.new()
	dialog.dialog_text = "Are yout sure?"
	dialog.confirmed.connect(func():
		SceneSwitcher.restart()
	)
	add_child(dialog)
	dialog.position = get_viewport().get_visible_rect().size / 2.0 - dialog.size / 2.0
	dialog.show()
