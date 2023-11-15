extends Node

var expression = Expression.new()

# Preload each individual foreign ship
var foreign_ship_v1 = preload("res://Ship/ForeignShipDownMov.tscn")
var foreign_ship_v2 = preload("res://Ship/ForeignShipSquareMov.tscn")
var foreign_ship_v3 = preload("res://Ship/ForeignShipDiagonalUpMov.tscn")

# Declare new foreign ships here...

# Foreign ships dict, their corresponding position on the map and type of foreing ship
var ships = {Vector2(100, -40): "1", Vector2(600, 1): "2", Vector2(500, 700): "3", Vector2(180, -40): "1"}

# New foreign ships dict, keeps track of dynamically created ships
# Keys are indexes, values are ship references
var new_ships = {}
var new_ships_key = 0

const START_STRING = "foreign_ship_v"

func _ready():
	var emitter = get_parent().get_node("TileMap")
	emitter.add_foreign_ships.connect(_on_add_foreign_ships)
	
func _process(_delta):
	if Input.is_action_just_pressed("switch_map_1") or \
	Input.is_action_just_pressed("switch_map_2") or \
	Input.is_action_just_pressed("switch_map_3"):
		for object in get_children():
			object.queue_free()
		pass
	#print(new_ships) # Testing purposes

func _on_add_foreign_ships():
	if !get_children():
			for ship_pos in ships.keys():
				var ship = ships[ship_pos]
				var string_for_instance = START_STRING + ship + ".instantiate()"
				expression.parse(string_for_instance)
				var foreign_ship_instance = expression.execute([], self)
				foreign_ship_instance.position = ship_pos
				add_child(foreign_ship_instance)
#	else: # Testing purposes
#		add_new_foreign_ship(1.0, 90, 5.0, 1, Vector2(-100, 350))
		
func add_new_foreign_ship(speed, starting_rotation_deg, reset_time_s, scale, position):
	var new_foreign_ship = load("res://Ship/ForeignShipObject.tscn").instantiate()
	var foreign_ship_object = new_foreign_ship.init(speed, starting_rotation_deg, reset_time_s, scale, position)
	add_child(foreign_ship_object)
	new_ships[new_ships_key] = foreign_ship_object
	new_ships_key += 1
	remove_new_foreign_ship(0)
	return foreign_ship_object
	
func remove_new_foreign_ship(idx):
	new_ships_key -= 1
	var obj = new_ships[idx]
	obj.queue_free()
	new_ships.erase(idx)
	
