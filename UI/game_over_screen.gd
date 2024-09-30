extends CanvasLayer


func _ready() -> void:
	print("Ready")
	GlobalServerData.game_over_now.connect(show_screen)
	
func show_screen():
	show()
	var remaining_time = Time.get_time_string_from_unix_time(GlobalServerData.remaining_time)
	var time = Time.get_time_string_from_unix_time(GlobalServerData.time_limit_seconds)
	$CenterContainer/Panel/VBoxContainer/GridContainer/RemainingTimeLabel.text = remaining_time + "/" + time
	$CenterContainer/Panel/VBoxContainer/GridContainer/PointsLabel.text = String.num(GlobalServerData.points) + "/" + String.num(GlobalServerData.goal_deliveries)
	$CenterContainer/Panel/VBoxContainer/GridContainer/FailedLabel.text = String.num(GlobalServerData.failed_missions.size()) + "/" + String.num(GlobalServerData.max_failures)


func _on_restart_button_pressed() -> void:
	hide()
	SceneSwitcher.restart()
