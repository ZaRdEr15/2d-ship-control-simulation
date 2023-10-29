extends CharacterBody2D

# Initial parameters for ship movement (connected with sliders)
var weight = 1
var max_speed = 150.0 / weight
var acceleration = 400.0 / weight
var deceleration = 100.0 * weight
var rotation_speed = 0.1 # ONLY VARIABLE WHICH CHANGES BY CONTROLLING!!
var friction = 150.0 * weight
var max_rotational_velocity = 0.8 / weight

const ROTATION_SPEED_STOP = 0.1
const WIND_DIRECTION_DEG = -90 # -90 is up direction
const WIND_POWER = 10

var crash_coeff = 0.25

var wind_vector = Vector2(0, 0)

var config = ConfigFile.new()

signal end_of_file

var movement_direction = Vector2(0, 0) # Initial direction where ship is positioned
var crash = false
var last_rotation_direction = 0
var rotation_direction_change = false
var rotation_before_stop = 0

var input_file : FileAccess
var is_recording = false
var is_playback = false

func _ready():
	rotation_degrees = -90
	set_scale(Vector2(weight, weight)) # Changes size and parameters of the ship
	movement_direction = Vector2.from_angle(rotation)
	create_cfg()
	ship_parameter_init()
	var emitter = get_parent() # Main node
	emitter.record_input.connect(_on_record_pressed)
	emitter.playback_input.connect(_on_playback_pressed)
	end_of_file.connect(_on_end_of_file_reached)

func _physics_process(delta):
	ship_movement(delta)
	ship_rotation(delta)
	move_and_slide()

func ship_movement(delta):
	# Save which input is pressed, can't allow to press both inputs at the same time
	var propel_forward = Input.get_axis("move_back", "move_forward")
	record_input(propel_forward, "UP", "DOWN")
	if is_playback:
		if input_file.eof_reached():
			emit_signal("end_of_file")
		else:
			propel_forward = playback_input("UP", "DOWN")
	# Move towards where facing
	if propel_forward: # We move in the last direction that we looked at, either in positive (forward) or negative (backwards)
		velocity += movement_direction * propel_forward * acceleration * delta
		if !crash:
			velocity = velocity.limit_length(max_speed)
		else:
			velocity = velocity.limit_length(max_speed * crash_coeff)
	else: # Over time if no input slow down the ship
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (deceleration * delta)
		else: # Stop the ship when fully slowed down
			velocity = Vector2.ZERO
	
func ship_rotation(delta):
	var rotation_direction = Input.get_axis("turn_left", "turn_right")
	# Rotate in the pressed direction
	record_input(rotation_direction, "RIGHT", "LEFT")
	if is_playback:
		if input_file.eof_reached():
			emit_signal("end_of_file")
		else:
			rotation_direction = playback_input("RIGHT", "LEFT")
	if rotation_direction:
		# If you press other direction of rotation, start slowing down, before back to maximum speed
		if rotation_direction != last_rotation_direction and rotation_direction_change == false:
			rotation_direction_change = true
			rotation_before_stop = last_rotation_direction
		last_rotation_direction = rotation_direction # save last rotation to remember turn
		if rotation_direction_change == false:
			if !crash:
				rotation += rotation_direction * rotational_acceleration(rotation_speed, max_rotational_velocity, delta) * delta
			else:
				rotation += rotation_direction * rotational_acceleration(rotation_speed, max_rotational_velocity * crash_coeff, delta) * delta
		else: # start slowing down until back to basic speed
			if rotation_speed > ROTATION_SPEED_STOP:
				rotation += rotation_before_stop * rotational_deceleration(rotation_speed, delta) * delta
			else:
				rotation_direction_change = false
	else: # continue movement of rotation when no input
		if rotation_speed > ROTATION_SPEED_STOP:
			rotation += last_rotation_direction * rotational_deceleration(rotation_speed, delta) * delta
	movement_direction = Vector2.from_angle(rotation)

#	print(rotation_speed)
#	print(rotation_direction)
#	print(rotation_direction_change)

func rotational_acceleration(curr_vel, max_velocity, delta):
	if curr_vel > max_velocity:
		return max_velocity
	else:
		rotation_speed = curr_vel + rotation_speed * delta
		return curr_vel
		
func rotational_deceleration(curr_vel, delta):
	rotation_speed = curr_vel - rotation_speed * delta
	return curr_vel
	
func create_cfg():
	if FileAccess.file_exists("user://ship.cfg"):
		return
	else:
		config.set_value("Ship_Parameters", "weight", weight)
		config.set_value("Ship_Parameters", "max_speed", max_speed)
		config.set_value("Ship_Parameters", "acceleration", acceleration)
		config.set_value("Ship_Parameters", "deceleration", deceleration)
		config.set_value("Ship_Parameters", "rotation_speed", rotation_speed)
		config.set_value("Ship_Parameters", "friction", friction)
		config.set_value("Ship_Parameters", "max_rotational_velocity", max_rotational_velocity)
		config.save("user://ship.cfg")

func ship_parameter_init():
	var err = config.load("user://ship.cfg")
	if err != OK:
		return
	weight = config.get_value("Ship_Parameters", "weight")
	recalculate_parameters()
	
func record_input(input_matching, input1, input2):
	if is_recording:
		var string
		match input_matching:
			1.0:
				string = input1
			-1.0:
				string = input2
			0.0:
				string = "NONE"
		input_file.store_line(string)
		
func playback_input(input1, input2):
	var input = input_file.get_line()
	match input:
		input1:
			input = 1.0
		input2:
			input = -1.0
		"NONE":
			input = 0.0
	return input 

func _on_record_pressed():
	if is_recording:
		# Create/open file and start saving input
		input_file = FileAccess.open("user://recorded_input.save", FileAccess.WRITE)
		if FileAccess.get_open_error() != OK:
			return
	else:
		# Close file
		input_file.close()
		
func _on_playback_pressed():
	if is_playback:
		# Read file for input
		input_file = FileAccess.open("user://recorded_input.save", FileAccess.READ)
		if FileAccess.get_open_error() != OK:
			return
	else:
		# Close file
		input_file.close()
		
func _on_end_of_file_reached():
	input_file.close()
	is_playback = false
	var label = get_parent().get_node("Playback")
	label.visible = false
	var main = get_parent()
	main.playback_pressed = false
	
func recalculate_parameters():
	max_speed = config.get_value("Ship_Parameters", "max_speed") / weight
	acceleration = config.get_value("Ship_Parameters", "acceleration") / weight
	deceleration = config.get_value("Ship_Parameters", "deceleration") / weight
	rotation_speed = config.get_value("Ship_Parameters", "rotation_speed")
	friction = config.get_value("Ship_Parameters", "friction") * weight
	max_rotational_velocity = config.get_value("Ship_Parameters", "max_rotational_velocity") / weight

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


func _on_weight_slider_value_changed(value):
	weight = value
	set_scale(Vector2(weight, weight))
	recalculate_parameters()
