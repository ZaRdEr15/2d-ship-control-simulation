extends Node2D

signal record_input
signal playback_input

var starting_position = Vector2(1285, 794)
var record_pressed = false
var playback_pressed = false

var is_wind_active = false

func _ready():
	var emitter = $TileMap
	emitter.map_switched.connect(reset_ship_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("restart_position"):
		reset_ship_position()
	elif Input.is_action_just_pressed("hide_help"):
		$GUI/Guide.visible = !$GUI/Guide.visible
	elif Input.is_action_just_pressed("show_ship_parameters"):
		$GUI/ShipParameters.visible = !$GUI/ShipParameters.visible
	elif Input.is_action_just_pressed("record_input") and playback_pressed != true:
		record_pressed = !record_pressed
		$Ship.is_recording = !$Ship.is_recording
		$GUI/Recording.visible = !$GUI/Recording.visible
		emit_signal("record_input")
	elif Input.is_action_just_pressed("playback_input") and record_pressed != true:
		playback_pressed = true
		$Ship.is_playback = !$Ship.is_playback
		$GUI/Playback.visible = !$GUI/Playback.visible
		emit_signal("playback_input")
	elif Input.is_action_just_pressed("toggle_wind"):
		$GUI/Wind.visible = !$GUI/Wind.visible
		if is_wind_active:
			$Ship.wind_vector = Vector2.ZERO
		else:
			calculate_wind_vector()
		is_wind_active = !is_wind_active
		

func reset_ship_position():
	$Ship.velocity = Vector2.ZERO
	$Ship.rotation_velocity = 0.0
	$Ship.position = starting_position
	$Ship.rotation_degrees = -90
	
func calculate_wind_vector():
	$Ship.wind_vector = Vector2.from_angle(deg_to_rad($Ship.WIND_DIRECTION_DEG)) * $Ship.WIND_POWER / $Ship.weight

func _on_weight_slider_value_changed(_value):
	if is_wind_active:
		calculate_wind_vector()
