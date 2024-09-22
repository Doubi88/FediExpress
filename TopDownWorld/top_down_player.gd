extends CharacterBody2D

class_name TopDownPlayer

@export var speed = 100

@onready var mission_window_packed = preload("res://UI/MissionsWindow.tscn")
@onready var animation = $AnimatedSprite

var looking_at_house: FediAccountHouse
var current_open_mission_window: MissionWindow
	
func _physics_process(delta: float) -> void:
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(global_position, to_global(Vector2(32, 0)))
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if (not result.is_empty()) and (result.collider is FediAccountHouse):
		looking_at_house = result.collider
	else:
		looking_at_house = null
	
func _process(delta: float) -> void:
	var new_velocity := Vector2.ZERO;
	if Input.is_action_pressed("walk forward"):
		new_velocity.y -= speed
	if Input.is_action_pressed("walk backward"):
		new_velocity.y += speed
	if Input.is_action_pressed("walk right"):
		new_velocity.x += speed
	if Input.is_action_pressed("walk left"):
		new_velocity.x -= speed

	velocity = lerp(velocity, new_velocity, 0.8)
	if velocity.length_squared() > 0:
		animation.play()
	else:
		animation.stop()
	
	var angle: float = rad_to_deg(new_velocity.angle())
	if angle >= 180:
		angle = 360 - angle
	if angle < 45:
		animation.animation = "right"
	elif angle < 135:
		animation.animation = "up"
	elif angle < 180:
		animation.animation = "left"

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if looking_at_house != null and event.is_action_pressed("toggle engine"):
		open_mission_window()

func open_mission_window() -> void:
	if current_open_mission_window == null:
		current_open_mission_window = mission_window_packed.instantiate()
		current_open_mission_window.account = looking_at_house.account_data
		current_open_mission_window.close_requested.connect(close_mission_window)
		add_child(current_open_mission_window)
		
func close_mission_window():
	remove_child(current_open_mission_window)
	current_open_mission_window.queue_free()
	current_open_mission_window = null
