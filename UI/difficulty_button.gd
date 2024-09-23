extends Button

func _on_pressed() -> void:
	var difficultyInt: int = GlobalServerData.difficulty
	difficultyInt = (difficultyInt + 1) % GlobalServerData.Difficulty.size()
	GlobalServerData.difficulty = difficultyInt as GlobalServerData.Difficulty

	text = "Difficulty: " + GlobalServerData.get_difficulty_name()

