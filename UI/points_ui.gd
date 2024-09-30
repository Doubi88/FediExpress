extends CanvasLayer


@onready var points_text: Label = $PanelContainer/VBoxContainer/PointsText
@onready var failures_text: Label = $PanelContainer/VBoxContainer/FailuresText
@onready var time_limit_text = $PanelContainer/VBoxContainer/TimeLimitText

func _process(delta: float) -> void:
	points_text.text = "Points: " + String.num(GlobalServerData.points)
	if GlobalServerData.goal_deliveries > 0:
		points_text.text += "/" + String.num(GlobalServerData.goal_deliveries)
		
	failures_text.text = "Failed: " + String.num(GlobalServerData.failed_missions.size())
	if GlobalServerData.max_failures > 0:
		failures_text.text += "/" + String.num(GlobalServerData.max_failures)
		
	var time_dict = Time.get_time_dict_from_unix_time(GlobalServerData.remaining_time)
	time_limit_text.text = "Time Limit: " + String.num(time_dict.hour * 60 + time_dict.minute) + ":"\
							+ String.num(time_dict.second) + " min"
