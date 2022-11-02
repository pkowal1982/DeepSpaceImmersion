extends Node3D

const VERTICAL_ANGLE := PI / 3.0
const HORIZONTAL_ANGLE := PI / 2.5
const POSITION := Vector3(0, 0, 5)

var started := Vector2()
var aspect: float


func _ready() -> void:
	var _ignore = get_viewport().size_changed.connect(on_size_changed)
	on_size_changed()


func _input(event) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_MIDDLE:
		started = event.position
	if event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_MIDDLE:
		set_tracking_position(event.position - started)
	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_MIDDLE:
		set_tracking_position(Vector2())


func _process(_delta: float) -> void:
	var vertical_angle := VERTICAL_ANGLE - deg_to_rad(Global.camera.fov) * 0.5
	var horizontal_fov := atan(tan(deg_to_rad(Global.camera.fov / 2.0)) * aspect) * 2.0
	var horizontal_angle := HORIZONTAL_ANGLE - horizontal_fov * 0.5

	transform = Transform3D.IDENTITY
	rotate_x(Global.tracking_position.y * vertical_angle)
	rotate_y(-Global.tracking_position.x * horizontal_angle)
	global_translate(POSITION)


func set_tracking_position(relative: Vector2) -> void:
	var v := relative / get_viewport().get_visible_rect().size
	v = v.clamp(-Vector2.ONE, Vector2.ONE)
	Global.set_tracking_position(v)


func on_size_changed() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	aspect = viewport_size.x / viewport_size.y

