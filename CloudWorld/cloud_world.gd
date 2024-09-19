extends Node2D

class_name CloudWorld

@onready var points_text: Label = $CanvasGroup/PointsText
@onready var cam: Camera2D = $TargetCamera
@onready var navigation = $Navigation

var vehicle: Helicopter

@onready var server_scene = preload("res://CloudWorld/fedi_server.tscn")
@onready var heli_scene = preload("res://Vehicles/helicopter.tscn")

@export var world_size: Vector2i = Vector2i(25, 25)
@export var world_builder: WorldBuilder

@export var background_border: Vector2i = Vector2i(30, 30)

var servers: Array[FediServer] = []
		
func _ready():
	#var bg: TextureRect = $BackgroundLayer/Background
	#bg.size = (Vector2(world_size + background_border)) * GridData.cell_size
	#bg.position = -(Vector2(background_border) * GridData.cell_size)

	GlobalServerData.server_data = world_builder.create_world_data()
	servers = world_builder.generate_cloud_world(self, GlobalServerData.server_data)
	
	vehicle = heli_scene.instantiate()
	var spawn_server: FediServer = servers.pick_random()
	
	var pos: Vector2 = (Vector2(spawn_server.position_in_grid) + Vector2(0, -spawn_server.size_in_grid.y / 2.0)) * GridData.cell_size
	add_child(vehicle)
	vehicle.global_position = pos
	cam.target = vehicle

	navigation.start = vehicle
	navigation.goals.append_array(servers)
		
			
func _process(delta: float) -> void:
	if vehicle != null and vehicle.current_up_force != null:
		var rot = vehicle.rotation - (PI / 2)
		var rotation_vector = Vector2.from_angle(rot)
		queue_redraw()
	points_text.text = "Points: " + String.num(GlobalServerData.points)
