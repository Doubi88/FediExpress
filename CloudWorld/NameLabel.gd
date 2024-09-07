extends Node

@onready var texture = $TextureRect
@onready var nameLabel = $NameLabel

func _process(delta):
	texture.size = nameLabel.size
