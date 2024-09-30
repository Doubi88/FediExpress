extends Container

@onready var minutes_spinner = $MinutesSpinner
@onready var seconds_spinner = $SecondsSpinner

func _ready() -> void:
	var time_limit_dict = Time.get_time_dict_from_unix_time(GlobalServerData.time_limit_seconds)
	minutes_spinner.value = time_limit_dict.hour * 60 + time_limit_dict.minute
	seconds_spinner.value = time_limit_dict.second


func _on_minutes_spinner_value_changed(value: float) -> void:
	update_time()

func _on_seconds_spinner_value_changed(value: float) -> void:
	update_time()

func update_time():
	var seconds: int = seconds_spinner.value
	var minutes: int = minutes_spinner.value
	var hours: int = floori(minutes / 60)
	minutes -= hours * 60
	var time = Time.get_unix_time_from_datetime_dict({"hour": hours, "minute": minutes, "second": seconds})
	GlobalServerData.time_limit_seconds = time
