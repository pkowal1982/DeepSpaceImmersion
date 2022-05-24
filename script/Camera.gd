extends Camera3D

const ZOOM_SPEED := 1.1
const ZOOM_IN_FOV := 36.0
const ZOOM_OUT_FOV := 72.0
const CROSS_HAIR_THRESHOLD := 37.0

var zoom_in := false


func _ready() -> void:
	Global.camera = self


func _process(delta: float) -> void:
	if zoom_in:
		fov /= ZOOM_SPEED * (1.0 + ZOOM_SPEED * delta)
	else:
		fov *= ZOOM_SPEED * (1.0 + ZOOM_SPEED * delta)
	fov = clampf(fov, ZOOM_IN_FOV, ZOOM_OUT_FOV)
	Global.hud.zoom(fov < CROSS_HAIR_THRESHOLD)


func _input(event) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_in = true
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_in = false
