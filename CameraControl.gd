extends Camera2D

const ZOOM_MIN = Vector2(0.7, 0.7)
const ZOOM_MAX = Vector2(1, 1)
const ZOOM_SPEED = Vector2(0.2, 0.2) 

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if zoom > ZOOM_MIN:
					zoom -= ZOOM_SPEED
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if zoom < ZOOM_MAX:
					zoom += ZOOM_SPEED
