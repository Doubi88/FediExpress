extends Node2D

const HELIPAD_ATLAS_X = 2
const HELIPAD_ATLAS_Y = 0
const GROUND_ATLAS_X = 0
const GROUND_ATLAS_Y = 0
const HOUSE_ATLAS_X = 0
const HOUSE_ATLAS_Y = 2

@onready var tilemap = $TileMap

@export var server_data: FediServerData

var created_view = false

func _process(delta):
	var direction = randi_range(0, 3)

	if not created_view:
		created_view = true
		var current_pos = Vector2.ZERO

		# Generate helipad
		generate_tiles_square(current_pos, Vector2i(HELIPAD_ATLAS_X, HELIPAD_ATLAS_Y))
		# Generate houses
		generate_neighbourhood(current_pos, server_data.accounts)
		
func generate_tiles_square(top_left: Vector2i, atlas_top_left: Vector2i):
	for x in range(2):
		for y in range(2):
			var coord = Vector2i(x, y)
			var atlas_coord = atlas_top_left + coord
			var real = top_left + coord

			tilemap.set_cell(0, real, 0, atlas_coord)

func generate_neighbourhood(helipad_top_left: Vector2i, accounts: Array[FediAccountData]):
	var occupied: PackedInt32Array = [0, 0, 0, 0]
	for account in accounts:
		var direction = randi_range(0, 3)
		var top_left = Vector2i.ZERO
		if direction == 0:
			# Up
			top_left = helipad_top_left + Vector2i(0, -2 - (occupied[direction] * 2))
		elif direction == 1:
			# Right
			top_left = helipad_top_left + Vector2i(2 + (occupied[direction] * 2), 0)
		elif direction == 2:
			# Down
			top_left = helipad_top_left + Vector2i(0, 2 + (occupied[direction] * 2))
		elif direction == 3:
			# Left
			top_left = helipad_top_left + Vector2i(-2 - (occupied[direction] * 2), 0)

		generate_tiles_square(top_left, Vector2i(GROUND_ATLAS_X, GROUND_ATLAS_Y))
		occupied[direction] += 1
		

