extends TileMap

var maps = {0: "Empty", 1: "Static objects", 2: "Dynamic objects"}
var n_maps = maps.size()
var curr_idx = 0

var map_label

signal add_foreign_ships
signal clear_foreign_ships
signal map_switched

func _ready():
	map_label = get_node("../MapSelection/CurrentMapName")
	map_label.text = maps[curr_idx] + " Map"

func switch_map(map):
	emit_signal("map_switched")
	clear_layer(1)
	match map:
		"Static objects":
			set_pattern(1, Vector2i(0, 0), tile_set.get_pattern(0))
		"Dynamic objects":
			emit_signal("add_foreign_ships")
	map_label.text = maps[curr_idx] + " Map"

func _on_previous_map_button_pressed():
	emit_signal("clear_foreign_ships")
	if curr_idx == 0:
		return
	curr_idx -= 1
	switch_map(maps[curr_idx])

func _on_next_map_button_pressed():
	if maps[curr_idx] != "Dynamic objects":
		emit_signal("clear_foreign_ships")
	if curr_idx == (n_maps - 1):
		return
	curr_idx += 1
	switch_map(maps[curr_idx])
