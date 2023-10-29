extends Control

var ship

func _ready():
	ship = get_parent().get_node("Ship")
	$WeightSlider.value = ship.weight
	$MaxSpeedSlider.value = ship.max_speed
	$AccelerationSlider.value = ship.acceleration
	$DecelerationSlider.value = ship.deceleration
	$RotationSpeedSlider.value = ship.rotation_speed
	$FrictionSlider.value = ship.friction
	$MaxRotationalVelocitySlider.value = ship.max_rotational_velocity
	
func _process(_delta):
	$RotationSpeedSlider.value = ship.rotation_speed
	
