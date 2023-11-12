extends CharacterBody2D

@export var max_speed = 1.8
@export var starting_rotation = 90
@export var restart_time = 13.0
@export var ship_scale = 1.3

var starting_pos = Vector2(0, 0)

func _ready():
	set_scale(Vector2(ship_scale, ship_scale))
	rotation_degrees = starting_rotation
	starting_pos = position
	$Timer.start()
	$Timer.wait_time = restart_time
	

func _physics_process(_delta):
	velocity = Vector2.from_angle(rotation) * max_speed
	move_and_collide(velocity)

func _on_timer_timeout():
	position = starting_pos
