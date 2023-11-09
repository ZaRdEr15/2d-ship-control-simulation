extends Node

var expression = Expression.new()

# Preload each individual foreign ship
var foreign_ship_v1 = preload("res://Ship/ForeignShipDownMov.tscn")
var foreign_ship_v2 = preload("res://Ship/ForeignShipSquareMov.tscn")
var foreign_ship_v3 = preload("res://Ship/ForeignShipDiagonalUpMov.tscn")

# Declare new foreign ships here...

# Foreign ships array, their version and corresponding position on the map (version to position is same index)
var ship_arr = ["1", "2", "3", "1"]
var pos_arr = [Vector2(100, -40), Vector2(600, 1), Vector2(500, 700), Vector2(180, -40)]
# Add number and position to the arrays at the same index and modify the pattern in the tilemap to add new ships

const START_STRING = "foreign_ship_v"

func _ready():
	var emitter = get_parent().get_node("TileMap")
	emitter.add_foreign_ships.connect(_on_add_foreign_ships)

func _on_add_foreign_ships():
	if !get_children():
			for i in pos_arr.size():
				var string_for_instance = START_STRING + ship_arr[i] + ".instantiate()"
				expression.parse(string_for_instance)
				var foreign_ship_instance = expression.execute([], self)
				foreign_ship_instance.position = pos_arr[i]
				add_child(foreign_ship_instance)
