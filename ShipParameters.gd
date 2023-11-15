extends Control

var ship

func _ready():
	ship = get_parent().get_node("Ship")
	$MaxSpeedSlider.value = ship.max_speed
	$AccelerationSlider.value = ship.acceleration
	$DecelerationSlider.value = ship.deceleration
	$FrictionSlider.value = ship.friction
	$MaxRotationalVelocitySlider.value = ship.max_rotational_velocity
	$WeightSlider.value = ship.weight
