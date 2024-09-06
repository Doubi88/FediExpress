extends RigidBody2D

class_name Helicopter

var throttle = 1 # -1 - 1
var rotation_rate = 0 # -1 - 1

var engine_on = false
var current_up_force = Vector2.ZERO
var current_rotation_force = 0

@onready var sprite = $Sprite

var gravity = Vector2.ZERO
var direction = -1

func _physics_process(delta):
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

func _integrate_forces(state: PhysicsDirectBodyState2D):
	gravity = state.total_gravity
	
func _process(delta):
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
