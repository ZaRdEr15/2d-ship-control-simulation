extends Node

var expression = Expression.new()

# Preload each individual foreign ship
var foreign_ship_v1 = preload("res://Ship/ForeignShipDownMov.tscn")
var foreign_ship_v2 = preload("res://Ship/ForeignShipSquareMov.tscn")
var foreign_ship_v3 = preload("res://Ship/ForeignShipDiagonalUpMov.tscn")

# Declare new foreign ships types here...

# Foreign ships dict, their corresponding position on the map and type of foreing ship
var ships = {Vector2(550, 50): "1", Vector2(1600, 200): "2", Vector2(1100, 1350): "3", Vector2(790, 50): "1"}

# New foreign ships dict, keeps track of dynamically created ships
# Keys are indexes, values are ship references

var foreign_ship_vX = preload("res://Ship/ForeignShipObject.tscn")
var new_ships = {}
var new_ships_key = 0

const START_STRING = "foreign_ship_v"

func _ready():
	var emitter = get_parent().get_node("TileMap")
	emitter.add_foreign_ships.connect(_on_add_foreign_ships)
	emitter.clear_foreign_ships.connect(_on_clear_foreign_ships)
	emitter.add_tilgu_ships.connect(_on_add_tilgu_ships)

func _on_add_foreign_ships():
	for ship_pos in ships.keys():
		var ship = ships[ship_pos]
		var string_for_instance = START_STRING + ship + ".instantiate()"
		expression.parse(string_for_instance)
		var foreign_ship_instance = expression.execute([], self)
		foreign_ship_instance.position = ship_pos
		add_child(foreign_ship_instance)
#		add_new_foreign_ship(1.0, 90, 5.0, 1, Vector2(-100, 350))

func _on_clear_foreign_ships():
	for object in get_children():
			object.queue_free()
	if new_ships.is_empty() != true:
		new_ships.clear()
		new_ships_key = 0
	#print(new_ships) # Testing purposes
	
func _on_add_tilgu_ships():
	add_new_foreign_ship(1.0, 90, 5.8, 0.80, Vector2(420, 280))
	add_new_foreign_ship(1.3, 180, 17, 1.1, Vector2(2200, 450))
	add_new_foreign_ship(0.5, 0, 16, 1.25, Vector2(300, 1050))
		
func add_new_foreign_ship(speed, starting_rotation_deg, reset_time_s, scale, position):
	var new_foreign_ship = foreign_ship_vX.instantiate()
	var foreign_ship_object = new_foreign_ship.init(speed, starting_rotation_deg, reset_time_s, scale, position)
	add_child(foreign_ship_object)
	new_ships[new_ships_key] = foreign_ship_object
	new_ships_key += 1
	#remove_new_foreign_ship(0) # Testing purposes
	return foreign_ship_object
	
func remove_new_foreign_ship(idx):
	new_ships_key -= 1
	var obj = new_ships[idx]
	obj.queue_free()
	new_ships.erase(idx)
	
