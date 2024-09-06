extends Node2D

@onready var test_text = $CanvasGroup/TestText
@onready var cam = $TargetCamera

var vehicle: Helicopter

@onready var server_scene = preload("res://World/fedi_server.tscn")
@onready var heli_scene = preload("res://Vehicles/helicopter.tscn")

var servers: Array[FediServer] = []

func _draw():
	if vehicle != null:
		for server in servers:
			draw_line(server.global_position, vehicle.global_position, Color.RED, 10, true)
		
func _ready():
	var buil = WorldBuilder.new()
	var server_datas = buil.create_world_data()
	servers = buil.generate_cloud_world(self, server_datas, server_scene)
	
	vehicle = heli_scene.instantiate()
	var spawn_server = servers.pick_random()
	
	var pos = spawn_server.global_position - Vector2(0, GridData.cell_size.y)
	add_child(vehicle)
	vehicle.global_position = pos
	cam.target = vehicle
	
			
func _process(delta):
	if vehicle != null and vehicle.current_up_force != null:
		var rot = vehicle.rotation - (PI / 2)
		var rotation_vector = Vector2.from_angle(rot)
		test_text.text = String.num(vehicle.current_up_force.x, 3) + ', ' + String.num(vehicle.current_up_force.y, 3) + "\n" + String.num(rotation / PI, 3) + " -> " + String.num(rotation_vector.x) + ", " + String.num(rotation_vector.y)
		
		queue_redraw()
