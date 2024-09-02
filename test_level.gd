extends Node2D

@onready var test_text = $TargetCamera/CanvasGroup/TestText
@onready var vehicle = $Helicopter

func _ready():
	var buil = WorldBuilder.new()
	var servers = buil.create_world()
	
	for server in servers:
		print(server.server_name)
		for account in server.accounts:
			print(account.account_name)
			
func _process(delta):
	if vehicle != null and vehicle.current_up_force != null:
		var rotation = vehicle.rotation - (PI / 2)
		var rotation_vector = Vector2.from_angle(rotation)
		test_text.text = String.num(vehicle.current_up_force.x, 3) + ', ' + String.num(vehicle.current_up_force.y, 3) + "\n" + String.num(rotation / PI, 3) + " -> " + String.num(rotation_vector.x) + ", " + String.num(rotation_vector.y)
