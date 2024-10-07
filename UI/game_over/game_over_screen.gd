extends CanvasLayer

@onready var text = $CenterContainer/Panel/VBoxContainer/GameOverText

func _ready() -> void:
	print("Ready")
	GlobalServerData.game_over_now.connect(show_screen)
	
func show_screen():
	show()
	if GlobalServerData.goal_deliveries > 0 and GlobalServerData.points >= GlobalServerData.goal_deliveries:
		text.text = "Finished"
	else:
		text.text = "Game Over"
	var remaining_time: String = Time.get_time_string_from_unix_time(floori(GlobalServerData.remaining_time))
	var time = Time.get_time_string_from_unix_time(floori(GlobalServerData.time_limit_seconds))
	$CenterContainer/Panel/VBoxContainer/GridContainer/RemainingTimeLabel.text = remaining_time + "/" + time
	$CenterContainer/Panel/VBoxContainer/GridContainer/PointsLabel.text = String.num(GlobalServerData.points) + "/" + String.num(GlobalServerData.goal_deliveries)
	$CenterContainer/Panel/VBoxContainer/GridContainer/FailedLabel.text = String.num(GlobalServerData.failed_missions.size()) + "/" + String.num(GlobalServerData.max_failures)


func _on_restart_button_pressed() -> void:
	hide()
	SceneSwitcher.restart()
