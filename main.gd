extends Node2D

var starting_position = Vector2(545, 283)
var foreign_ship = load("res://Ship/ForeignShip.tscn")
var pattern_set = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("restart_position"):
		reset_ship_position()
	elif Input.is_action_just_pressed("switch_map_1"):
		$TileMap.clear_layer(1)
		reset_ship_position()
	elif Input.is_action_just_pressed("switch_map_2"):
		$TileMap.clear_layer(1)
		$TileMap.set_pattern(1, Vector2i(0, 0), $TileMap.tile_set.get_pattern(0))
		reset_ship_position()
	elif Input.is_action_just_pressed("switch_map_3"):
		$TileMap.clear_layer(1)
		$TileMap.set_pattern(1, Vector2i(-5, 3), $TileMap.tile_set.get_pattern(1))
		if !$TileMap.get_children() and pattern_set:
			var arr = $TileMap.get_used_cells(1)
			for i in arr.size():
				var foreign_ship_instance = foreign_ship.instantiate()
				foreign_ship_instance.position = $TileMap.map_to_local(arr[i])
				$TileMap.add_child(foreign_ship_instance)
		pattern_set = true
		reset_ship_position()

func reset_ship_position():
	$Ship.position = starting_position
