extends CharacterBody2D

# Values for movement
var max_speed = 150.0
var acceleration = 400.0
var deceleration = 100.0
var rotation_speed = 0.1
var friction = 150.0
var max_rotational_velocity = 0.8

var config = ConfigFile.new()

# Initial direction where ship is positioned
var movement_direction = Vector2(0, 0)
var crash = false
var last_rotation_direction = 0
var rotation_direction_change = false

func _ready():
	rotation_degrees = -90
	movement_direction = Vector2.from_angle(rotation)
	ship_parameter_init()

func _physics_process(delta):
	ship_movement(delta)
	ship_rotation(delta)
	move_and_slide()

func ship_movement(delta):
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
			
func ship_rotation(delta):
	var rotation_direction = Input.get_axis("turn_left", "turn_right")
	# Rotate in the pressed direction
	if rotation_direction:
		# If you press other direction of rotation, start slowing down, before back to maximum speed
		if rotation_direction != last_rotation_direction and rotation_direction_change == false:
			rotation_direction_change = true
		last_rotation_direction = rotation_direction # save last rotation to remember turn
		if rotation_direction_change == false:
			if !crash:
				rotation += rotation_direction * rotational_acceleration(rotation_speed, max_rotational_velocity, delta) * delta
			else:
				rotation += rotation_direction * rotational_acceleration(rotation_speed, 0.2, delta) * delta
		else: # start slowing down until back to basic speed
			if rotation_speed > 0.1:
				rotation += rotation_direction * rotational_deceleration(rotation_speed * 0.95, delta) * delta
			else:
				rotation_direction_change = false
	else: # continue movement of rotation when no input
		if rotation_speed > 0.1:
			rotation += last_rotation_direction * rotational_deceleration(rotation_speed, delta) * delta
	movement_direction = Vector2.from_angle(rotation)

	print(rotation_speed)

func rotational_acceleration(curr_vel, max_velocity, delta):
	if curr_vel > max_velocity:
		return max_velocity
	else:
		rotation_speed = curr_vel + rotation_speed * delta
		return curr_vel
		
func rotational_deceleration(curr_vel, delta):
	rotation_speed = curr_vel - rotation_speed * delta
	return curr_vel

func ship_parameter_init():
	var err = config.load("res://ship.cfg")
	if err != OK:
		return
	max_speed = config.get_value("Ship_Parameters", "max_speed")
	acceleration = config.get_value("Ship_Parameters", "acceleration")
	deceleration = config.get_value("Ship_Parameters", "deceleration")
	rotation_speed = config.get_value("Ship_Parameters", "rotation_speed")
	friction = config.get_value("Ship_Parameters", "friction")
	max_rotational_velocity = config.get_value("Ship_Parameters", "max_rotational_velocity")

func _on_area_2d_body_entered(_body):
	crash = true

func _on_area_2d_body_exited(_body):
	crash = false


func _on_max_speed_slider_value_changed(value):
	max_speed = value


func _on_acceleration_slider_value_changed(value):
	acceleration = value


func _on_deceleration_slider_value_changed(value):
	deceleration = value


func _on_rotation_speed_slider_value_changed(value):
	rotation_speed = value


func _on_friction_slider_value_changed(value):
	friction = value


func _on_max_rotational_velocity_slider_value_changed(value):
	max_rotational_velocity = value
