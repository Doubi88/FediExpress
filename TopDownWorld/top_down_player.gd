extends CharacterBody2D

@export var speed = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_velocity = 0;
	if Input.is_action_pressed("walk forward"):
		new_velocity += speed
	if Input.is_action_pressed("walk backward"):
		new_velocity -= speed
	if Input.is_action_pressed("walk right"):
		rotation_degrees += 3
	if Input.is_action_pressed("walk left"):
		rotation_degrees -= 3

	velocity = lerp(velocity, new_velocity * Vector2.from_angle(rotation), 0.8)
	move_and_slide()
	
