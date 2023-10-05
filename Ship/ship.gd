extends CharacterBody2D

@export var move_speed = 200.0
@export var rotation_speed = 0.01
var movement_direction = Vector2(1, 0)


func _physics_process(delta):
	var propell_forward = Input.get_axis("move_back", "move_forward")
	# Move towards where facing
	if propell_forward:
		velocity = movement_direction * propell_forward * move_speed
	else:
		velocity = Vector2(0, 0);
	
	var rotation_direction = Input.get_axis("turn_left", "turn_right")
	if rotation_direction:
		rotation += rotation_direction * rotation_speed
		movement_direction = movement_direction.from_angle(rotation)
	
	print(rotation_degrees)
	print(movement_direction)
	
	move_and_slide()
