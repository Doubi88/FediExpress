extends Node2D

class_name ServerWorld

const HELIPAD_ATLAS_X = 2
const HELIPAD_ATLAS_Y = 0
const GROUND_ATLAS_X = 0
const GROUND_ATLAS_Y = 0
const HOUSE_ATLAS_X = 0
const HOUSE_ATLAS_Y = 2

enum Direction {
	UP, RIGHT, DOWN, LEFT
}

@onready var tilemap = $TileMap
@onready var player = $TopDownPlayer
@onready var area64Scene = preload("res://TopDownWorld/area_64x_64.tscn")
@onready var house_scene = preload("res://TopDownWorld/fedi_account_house.tscn")

@export var server_data: FediServerData

var can_leave = false
var rand: RandomNumberGenerator = RandomNumberGenerator.new()
var created_view = false

var cloud_world: CloudWorld

func _process(delta):
	if not created_view:
		rand.seed = server_data.server_name.hash()
		created_view = true
		var current_pos = Vector2.ZERO
		
		# Generate paths and houses
		var helipad = generate_neighbourhood(current_pos, server_data.accounts)
		
		var touchHelipadScene: Area2D = area64Scene.instantiate()
		touchHelipadScene.body_entered.connect(on_helipad_body_entered)
		touchHelipadScene.body_exited.connect(on_helipad_body_exited)
		self.add_child(touchHelipadScene)
		touchHelipadScene.position = tilemap.map_to_local(helipad) + (tilemap.tile_set.tile_size / 2.0)
		
		player.position = tilemap.map_to_local(helipad)
		
func generate_tiles_square(top_left: Vector2i, atlas_top_left: Vector2i):
	for x in range(2):
		for y in range(2):
			var coord = Vector2i(x, y)
			var atlas_coord = atlas_top_left + coord
			var real = top_left + coord

			tilemap.set_cell(0, real, 0, atlas_coord)

func generate_neighbourhood(helipad_top_left: Vector2i, accounts: Array[FediAccountData]) -> Vector2i:
	var grid_diameter: int = max(floor(accounts.size() / 2.0), 5)
	
	var house_positions: Dictionary = {}
	
	var helipad_pos: Vector2i = Vector2i(floor(grid_diameter / 2.0), floor(grid_diameter / 2.0))
	
	var astar: AStarGrid2D = AStarGrid2DRandomWeight.new(rand)
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.region = Rect2i(0, 0, grid_diameter, grid_diameter)
	astar.update()
	
	for account in accounts:
		var pos: Vector2i = Vector2i(rand.randi_range(0, grid_diameter - 1), rand.randi_range(0, grid_diameter - 1))
		while pos == helipad_pos or house_positions.has(pos):
			pos = Vector2i(rand.randi_range(0, grid_diameter), rand.randi_range(0, grid_diameter))
		house_positions[pos] = account
		astar.set_point_solid(pos, true)
	astar.update()
	
	for pos: Vector2i in house_positions:
		astar.set_point_solid(pos, false)
		var path: PackedVector2Array = astar.get_point_path(helipad_pos, pos, true)
		astar.set_point_solid(pos, true)
		for p: Vector2 in path:
			var pi: Vector2i = Vector2i(p)
			if pi == helipad_pos:
				generate_tiles_square(pi * 2, Vector2i(HELIPAD_ATLAS_X, HELIPAD_ATLAS_Y))
			elif pi == pos:
				generate_tiles_square(pi * 2, Vector2i(GROUND_ATLAS_X, GROUND_ATLAS_Y))

				var house: FediAccountHouse = house_scene.instantiate()
				add_child(house)
				house.account_data = house_positions[pos]
				house.position = tilemap.map_to_local(pi * 2) + (Vector2(tilemap.tile_set.tile_size) / 2.0)
			else:
				generate_tiles_square(pi * 2, Vector2i(GROUND_ATLAS_X, GROUND_ATLAS_Y))
	return helipad_pos * 2

func on_helipad_body_entered(body: Node2D) -> void:
	print(body, "entered")
	if body == player:
		can_leave = true
func on_helipad_body_exited(body: Node2D) -> void:
	print(body, "exited")
	if body == player:
		can_leave = false

func _unhandled_input(event: InputEvent) -> void:
	if can_leave:
		if event.is_action_pressed("enter_leave vehicle"):
			if cloud_world == null:
				var cloud_world_packed = preload("res://CloudWorld/cloud_world.gd")
				cloud_world = cloud_world_packed.instantiate()
			get_tree().root.add_child(cloud_world)
			queue_free()
