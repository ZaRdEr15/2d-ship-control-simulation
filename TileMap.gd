extends TileMap

signal add_foreign_ships

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("switch_map_1"):
		clear_layer(1)
	elif Input.is_action_just_pressed("switch_map_2"):
		clear_layer(1)
		set_pattern(1, Vector2i(0, 0), tile_set.get_pattern(0))
	elif Input.is_action_just_pressed("switch_map_3"):
		clear_layer(1)
		emit_signal("add_foreign_ships")
