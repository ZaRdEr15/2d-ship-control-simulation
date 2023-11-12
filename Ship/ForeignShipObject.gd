extends CharacterBody2D

var max_speed
var restart_time
var starting_pos : Vector2

func init(speed = 1.0, starting_rotation = 0, time = 5.0, ship_scale = 1, pos = Vector2(0, 0)):
	max_speed = speed
	restart_time = time
	set_position(pos)
	set_rotation_degrees(starting_rotation)
	set_scale(Vector2(ship_scale, ship_scale))
	return self

func _ready():
	starting_pos = position
	$Timer.start()
	$Timer.wait_time = restart_time
	

func _physics_process(_delta):
	velocity = Vector2.from_angle(rotation) * max_speed
	move_and_collide(velocity)

func _on_timer_timeout():
	position = starting_pos
