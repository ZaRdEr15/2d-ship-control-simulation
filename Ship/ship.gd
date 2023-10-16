extends CharacterBody2D

# Values for movement (can be changed in editor)
@export var max_speed = 150.0
@export var acceleration = 400.0
@export var deceleration = 100.0
@export var rotation_speed = 0.1
@export var friction = 150.0
@export var max_rotational_velocity = 0.8

# Initial direction where ship is positioned
var movement_direction = Vector2(0, 0)
var crash = false
var last_rotation_direction = 0

func _ready():
	rotation_degrees = -90
	movement_direction = Vector2.from_angle(rotation)

func _physics_process(delta):
	# Save which input is pressed, can't allow to press both inputs at the same time
	var propell_forward = Input.get_axis("move_back", "move_forward")
	# Move towards where facing
	if propell_forward: # We move in the last direction that we looked at, either in positive (forward) or negative (backwards)
		velocity += movement_direction * propell_forward * acceleration * delta
		if !crash:
			velocity = velocity.limit_length(max_speed)
		else:
			velocity = velocity.limit_length(40.0)
	else: # Over time if no input slow down the ship
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (deceleration * delta)
		else: # Stop the ship when fully slowed down
			velocity = Vector2.ZERO
	
	
	var rotation_direction = Input.get_axis("turn_left", "turn_right")
	# Rotate in the pressed direction (CONSTANT SPEED, IMMEDIATE STOP)
	if rotation_direction:
		last_rotation_direction = rotation_direction
		if !crash:
			rotation += rotation_direction * rotational_acceleration(rotation_speed, max_rotational_velocity, delta) * delta
		else:
			rotation += rotation_direction * rotational_acceleration(rotation_speed, 0.2, delta) * delta
		movement_direction = Vector2.from_angle(rotation)
	else:
		if rotation_speed > 0.1:
			rotation += last_rotation_direction * rotational_deceleration(rotation_speed, delta) * delta
			movement_direction = Vector2.from_angle(rotation)
		
	
	move_and_slide()


func rotational_acceleration(curr_vel, max_velocity, delta):
	if curr_vel > max_velocity:
		return max_velocity
	else:
		rotation_speed = curr_vel + rotation_speed * delta
		return curr_vel
		
func rotational_deceleration(curr_vel, delta):
	rotation_speed = curr_vel - rotation_speed * delta
	return curr_vel


func _on_area_2d_body_entered(_body):
	crash = true

func _on_area_2d_body_exited(_body):
	crash = false
