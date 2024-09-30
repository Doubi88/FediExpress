extends Button

func _ready() -> void:
	update_text()
	
func _on_pressed() -> void:
	var difficultyInt: int = GlobalServerData.difficulty
	difficultyInt = (difficultyInt + 1) % GlobalServerData.Difficulty.size()
	GlobalServerData.difficulty = difficultyInt as GlobalServerData.Difficulty
	update_text()
	
func update_text() -> void:
	text = "Difficulty: " + GlobalServerData.get_difficulty_name()
