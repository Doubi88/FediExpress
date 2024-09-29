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
	_show_tutorial()
		
			
func _process(delta: float) -> void:
	points_text.text = "Points: " + String.num(GlobalServerData.points) + "\nFailed:" + String.num(GlobalServerData.failed_missions.size())

func _show_tutorial():
	Dialogue.text_pages = [
		"Greetings! Welcome to your new job in the fediverse! " + \
		"If you didn't know already: Your job is to deliver " + \
		"posts around the servers and accounts.",
		"To start the engine of your helicopter just press E.",
		"You can then control it with W, A, S and D. Oh, and if you get stuck somewhere, just land on a cloud, stop your engine and press R.",
		"Look for the red exclamation marks. They tell you, where a post is ready to be taken.",
		"As soon as you land, stop the engine, press F or Enter to leave your helicopter, " + \
		"and walk to the account.",
		"Press E in front of the account to view the list of posts and take some of them.",
		"When you're ready, return to your helicopter and press F or Enter again.",
		"That's everything you need to know. Good luck!"
	]
								  
	Dialogue.speaker_name = "Chief Godot"
	Dialogue.show()
	
