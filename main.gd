extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("restart_position"):
		reset_ship_position()
	elif  Input.is_action_just_pressed("switch_map_1"):
		$TileMap.clear_layer(1)
		reset_ship_position()
	elif Input.is_action_just_pressed("switch_map_2"):
		$TileMap.set_pattern(1, Vector2i(0, 0), $TileMap.tile_set.get_pattern(0))
		reset_ship_position()

func reset_ship_position():
	$Ship.position = Vector2(545, 283)
