extends Control
#var ship = main_tree.get_node("Ship")

# Called when the node enters the scene tree for the first time.
func _ready():
	var ship = get_parent().get_node("Ship")
	$MaxSpeedSlider.value = ship.max_speed
	$AccelerationSlider.value = ship.acceleration
	$DecelerationSlider.value = ship.deceleration
	$RotationSpeedSlider.value = ship.rotation_speed
	$FrictionSlider.value = ship.friction
	$MaxRotationalVelocitySlider.value = ship.max_rotational_velocity
	
