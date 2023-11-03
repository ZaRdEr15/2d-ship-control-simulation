extends TileMap

var expression = Expression.new()

var pattern_set = false

var foreign_ship_v1 = preload("res://Ship/ForeignShipDownMov.tscn")
var foreign_ship_v2 = preload("res://Ship/ForeignShipSquareMov.tscn")
var foreign_ship_v3 = preload("res://Ship/ForeignShipDiagonalUpMov.tscn")

var pos_arr = [Vector2i(9, -4), Vector2i(48, 1), Vector2i(43, 42)]

const START_STRING = "foreign_ship_v"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("switch_map_1"):
		clear_layer(1)
	elif Input.is_action_just_pressed("switch_map_2"):
		clear_layer(1)
		set_pattern(1, Vector2i(0, 0), tile_set.get_pattern(0))
	elif Input.is_action_just_pressed("switch_map_3"):
		clear_layer(1)
		set_pattern(1, pos_arr[0], tile_set.get_pattern(1))
		add_foreign_ship_children()
		pattern_set = true

func add_foreign_ship_children():
	if !get_children() and pattern_set:
			for i in pos_arr.size():
				var string_for_instance = START_STRING + str(i + 1) + ".instantiate()"
				expression.parse(string_for_instance)
				var foreign_ship_instance = expression.execute([], self)
				foreign_ship_instance.position = map_to_local(pos_arr[i])
				add_child(foreign_ship_instance)
