extends CharacterBody2D

@export var max_speed = 2.4
@export var starting_rotation = 0
@export var restart_time = 11.0

var starting_pos = Vector2(0, 0)

func _ready():
	print(position)
	rotation_degrees = starting_rotation
	starting_pos = position
	$Timer.start()
	$Timer.wait_time = restart_time
	

func _physics_process(_delta):
	velocity = Vector2.from_angle(rotation) * max_speed
	move_and_collide(velocity)
	if Input.is_action_just_pressed("switch_map_1") or Input.is_action_just_pressed("switch_map_2"):
		queue_free()

func _on_timer_timeout():
	position = starting_pos
