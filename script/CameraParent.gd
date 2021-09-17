extends Node3D

const MAX_ANGLE := 0.25 * PI

var started := Vector2()


func _ready() -> void:
	Global.camera = $Camera


func _input(event) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_MIDDLE:
		started = event.position
	if event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_MIDDLE:
		set_tracking_position(event.position - started)
	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_MIDDLE:
		set_tracking_position(Vector2())


func _process(_delta: float) -> void:
	transform = Transform3D.IDENTITY
	rotate_x(Global.tracking_position.y * MAX_ANGLE)
	rotate_y(-Global.tracking_position.x * MAX_ANGLE)


func set_tracking_position(relative: Vector2) -> void:
	var v := relative / get_viewport().get_visible_rect().size
	v = v.clamp(Vector2(-0.5, -0.5), Vector2(0.5, 0.5))
	Global.set_tracking_position(v)
