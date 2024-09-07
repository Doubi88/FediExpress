extends Node2D

var cobble_floor = preload("res://TopDownWorld/CobblePlaceholder.png")
var house = preload("res://TopDownWorld/HousePlaceholder.png")

@onready var tiles_parent = $TilesParent

@onready var landing_pad = $TilesParent/HeliLanding

@export var server_data: FediServerData

var created_view = false

func _process(delta):
	var direction = randi_range(0, 3)

	if not created_view:
		created_view = true
		var current_pos = landing_pad.position
		for account in server_data.accounts:
			var sprite = Sprite2D.new()
			tiles_parent.add_child(sprite)
			sprite.texture = cobble_floor

			var add = Vector2.ZERO
			if direction == 0:
				add.x = -64
			elif direction == 1:
				add.y = -64
			if direction == 2:
				add.x = 64
			elif direction == 3:
				add.y = 64

			sprite.position = current_pos + add
			current_pos = sprite.position
