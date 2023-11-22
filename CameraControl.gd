extends Camera2D

const ZOOM_MIN = Vector2(0.75001, 0.75001)
const ZOOM_MAX = Vector2(1.5, 1.5)
const ZOOM_SPEED = Vector2(0.05, 0.05)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if zoom > ZOOM_MIN: # Zooming out
					zoom -= ZOOM_SPEED
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if zoom < ZOOM_MAX: # Zooming in
					zoom += ZOOM_SPEED
