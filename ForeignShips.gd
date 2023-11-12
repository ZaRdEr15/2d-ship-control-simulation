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

var new_ships_arr = []

const START_STRING = "foreign_ship_v"

func _ready():
	var emitter = get_parent().get_node("TileMap")
	emitter.add_foreign_ships.connect(_on_add_foreign_ships)
	
func _process(_delta):
	if Input.is_action_just_pressed("switch_map_1") or \
	Input.is_action_just_pressed("switch_map_2") or \
	Input.is_action_just_pressed("switch_map_3"):
#		for object in get_children():
#			object.queue_free()
		pass
	print(new_ships_arr)

func _on_add_foreign_ships():
	if !get_children():
			for i in pos_arr.size():
				var string_for_instance = START_STRING + ship_arr[i] + ".instantiate()"
				expression.parse(string_for_instance)
				var foreign_ship_instance = expression.execute([], self)
				foreign_ship_instance.position = pos_arr[i]
				add_child(foreign_ship_instance)
	else:
		add_new_foreign_ship()
		
func add_new_foreign_ship():
	var new_foreign_ship = load("res://Ship/ForeignShipObject.tscn").instantiate()
	var foreign_ship_object = new_foreign_ship.init(2.0, 0, 5.0, 2, Vector2(-100, 350))
	add_child(foreign_ship_object)
	new_ships_arr.append(foreign_ship_object)
	
func remove_new_foreign_ship(obj):
	obj.queue_free()
	new_ships_arr.erase(obj)
	
