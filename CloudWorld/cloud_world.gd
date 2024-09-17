extends Node2D

class_name CloudWorld

@onready var test_text: Label = $CanvasGroup/TestText
@onready var cam: Camera2D = $TargetCamera

var vehicle: Helicopter

@onready var server_scene = preload("res://CloudWorld/fedi_server.tscn")
@onready var heli_scene = preload("res://Vehicles/helicopter.tscn")

var servers: Array[FediServer] = []

func _draw():
	if vehicle != null:
		for server in servers:
			draw_line(server.global_position, vehicle.global_position, Color.RED, 10, true)
		
func _ready():
	var buil = WorldBuilder.new()
	GlobalServerData.server_data = buil.create_world_data()
	servers = buil.generate_cloud_world(self, GlobalServerData.server_data, server_scene)
	
	vehicle = heli_scene.instantiate()
	var spawn_server = servers.pick_random()
	
	var pos = spawn_server.global_position - Vector2(0, GridData.cell_size.y)
	add_child(vehicle)
	vehicle.global_position = pos
	cam.target = vehicle
	
			
func _process(delta: float) -> void:
	if vehicle != null and vehicle.current_up_force != null:
		var rot = vehicle.rotation - (PI / 2)
		var rotation_vector = Vector2.from_angle(rot)
		queue_redraw()
	test_text.text = "Points: " + String.num(GlobalServerData.points)
