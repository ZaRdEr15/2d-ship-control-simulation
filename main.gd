extends Node2D

signal record_input
signal playback_input

var starting_position = Vector2(545, 283)
var record_pressed = false
var playback_pressed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("restart_position") or\
	Input.is_action_just_pressed("switch_map_1") or\
	Input.is_action_just_pressed("switch_map_2") or\
	Input.is_action_just_pressed("switch_map_3"):
		reset_ship_position()
	elif Input.is_action_just_pressed("hide_help"):
		$Guide.visible = !$Guide.visible
	elif Input.is_action_just_pressed("show_ship_parameters"):
		$ShipParameters.visible = !$ShipParameters.visible
	elif Input.is_action_just_pressed("record_input") and playback_pressed != true:
		record_pressed = !record_pressed
		$Ship.is_recording = !$Ship.is_recording
		$Recording.visible = !$Recording.visible
		emit_signal("record_input")
	elif Input.is_action_just_pressed("playback_input") and record_pressed != true:
		playback_pressed = true
		$Ship.is_playback = !$Ship.is_playback
		$Playback.visible = !$Playback.visible
		emit_signal("playback_input")
		

func reset_ship_position():
	$Ship.position = starting_position
	$Ship.rotation_degrees = -90
