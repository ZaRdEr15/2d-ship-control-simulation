extends CharacterBody2D

@export var max_speed = 2.0
@export var starting_rotation = 0
@export var restart_time = 3
@export var ship_scale = 0.75

var rotate = false
var initial_rot = 0

func _ready():
	set_scale(Vector2(ship_scale, ship_scale))
	rotation_degrees = starting_rotation
	$Timer.start()
	$Timer.wait_time = restart_time
	

func _physics_process(_delta):
	if rotate:
		velocity = Vector2.ZERO
		rotation_degrees += 1
		initial_rot += 1
		if initial_rot == 90:
			initial_rot = 0
			rotate = false
	else:
		velocity = Vector2.from_angle(rotation) * max_speed
	move_and_collide(velocity)

func _on_timer_timeout():
	rotate = true
		
