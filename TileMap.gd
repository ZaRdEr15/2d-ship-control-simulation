extends TileMap

var foreign_ship = load("res://Ship/ForeignShip.tscn")
var pattern_set = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("switch_map_1"):
		clear_layer(1)
	elif Input.is_action_just_pressed("switch_map_2"):
		clear_layer(1)
		set_pattern(1, Vector2i(0, 0), tile_set.get_pattern(0))
	elif Input.is_action_just_pressed("switch_map_3"):
		clear_layer(1)
		set_pattern(1, Vector2i(-5, 3), tile_set.get_pattern(1))
		add_foreign_ship_children()
		pattern_set = true
		
func add_foreign_ship_children():
	if !get_children() and pattern_set:
			var arr = get_used_cells(1)
			for i in arr.size():
				var foreign_ship_instance = foreign_ship.instantiate()
				foreign_ship_instance.position = map_to_local(arr[i])
				add_child(foreign_ship_instance)
