extends CanvasLayer

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
