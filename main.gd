extends Node2D

var starting_position = Vector2(545, 283)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("restart_position") or\
	Input.is_action_just_pressed("switch_map_1") or\
	Input.is_action_just_pressed("switch_map_2") or\
	Input.is_action_just_pressed("switch_map_3"):
		reset_ship_position()
	elif Input.is_action_just_pressed("hide_help"):
		$Guide.visible = toggle_bool($Guide.visible)
	elif Input.is_action_just_pressed("show_ship_parameters"):
		$ShipParameters.visible = toggle_bool($ShipParameters.visible)

func reset_ship_position():
	$Ship.position = starting_position
	
func toggle_bool(state):
	if state:
		return false
	return true
