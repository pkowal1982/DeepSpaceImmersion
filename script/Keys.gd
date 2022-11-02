extends CheckBox

const ACCELERATION := 0.75
const MIN_SPEED := -0.4
const MAX_SPEED := 0.4
const DECELERATION := 0.001
const BRAKE_BELOW := 0.05

var horizontal_speed := 0.0
var vertical_speed := 0.0


func _ready():
	var _ignore = toggled.connect(on_toggled)


func _process(delta: float) -> void:
	var horizontal := Input.get_axis("left", "right")
	var vertical := Input.get_axis("down", "up")
	if Vector2(horizontal, vertical).length() < BRAKE_BELOW:
		horizontal_speed *= pow(DECELERATION, delta)
		vertical_speed *= pow(DECELERATION, delta)
	else:
		horizontal_speed += horizontal * ACCELERATION * delta
		vertical_speed += vertical * ACCELERATION * delta
	horizontal_speed = clamp(horizontal_speed, MIN_SPEED, MAX_SPEED)
	vertical_speed = clamp(vertical_speed, MIN_SPEED, MAX_SPEED)
	var speed := Vector2(horizontal_speed, vertical_speed)
	var previous_position := Global.tracking_position
	Global.set_tracking_position(Global.tracking_position + speed)
	horizontal_speed = Global.tracking_position.x - previous_position.x
	vertical_speed = Global.tracking_position.y - previous_position.y


func on_toggled(active: bool) -> void:
	horizontal_speed = 0.0
	vertical_speed = 0.0
	set_process(active)
	print("toggle: ", active)
