extends RigidBody2D

class_name Helicopter

var throttle: float = 1 # -1 - 1
var rotation_rate: float = 0 # -1 - 1

var engine_on: bool = false
var current_up_force: Vector2 = Vector2.ZERO
var current_rotation_force: float = 0

@onready var sprite = $Sprite

var gravity = Vector2.ZERO
var direction = -1
var do_reset = false

func _physics_process(delta: float) -> void:

	var landed_server = is_landed()
	if landed_server != null:
		if Input.is_action_just_pressed("enter_leave vehicle"):
			var server_scene: ServerWorld = preload("res://TopDownWorld/server_world.tscn").instantiate()
			server_scene.server_data = landed_server.server_data
			get_tree().root.add_child(server_scene)
			var cloud_world = get_node("/root/CloudWorld")
			get_tree().root.remove_child(cloud_world)
			server_scene.cloud_world = cloud_world
		elif Input.is_action_just_pressed("reset vehicle"):
			do_reset = true
			apply_central_force(Vector2.ZERO) # Wake the rigid body up, so _integrate_forces is called
	else:
		var up_vector = Vector2.from_angle(rotation - (PI / 2.0))
		var up_force_length = throttle * mass * (-gravity.y * up_vector).y
		current_up_force = up_force_length * up_vector
		
		apply_central_force(current_up_force)
		apply_torque(rotation_rate * 500000)
		
		if (direction < 0 && linear_velocity.x > 5):
			sprite.flip_h = true
			direction = 1
		elif (direction > 0 && linear_velocity.x < -5):
			sprite.flip_h = false
			direction = -1
		

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	gravity = state.total_gravity
	if do_reset:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		current_up_force = Vector2.ZERO
		current_rotation_force = 0
		throttle = 0
		rotation_rate = 0
		rotation = 0
		do_reset = false
	
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("toggle engine")):
		engine_on = !engine_on
		if engine_on:
			sprite.frame = 1
		else:
			sprite.frame = 0
	
	if (engine_on):
		throttle = Input.get_axis("throttle down", "throttle up") + 1
		rotation_rate = Input.get_axis("yaw left", "yaw right")
	else:
		throttle = 0
		rotation_rate = 0


func is_landed() -> FediServer:
	if not engine_on:
		var space_state = get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, 64))
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if (not result.is_empty()) and (result.collider is FediServer):
			return result.collider
		else:
			return null
	else:
		return null
