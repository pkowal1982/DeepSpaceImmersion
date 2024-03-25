extends Node

signal tracking_position_updated(tracking_position)
signal masked_image_updated(masked_image)
signal game_over()
signal show_help(visible)
signal frame_changed()

enum Mode { KEYS, HSV_TRACK, HSV_MASK, MARKER_TRACK, JOYSTICK }

const DISTANCE := 0.01
const MIN_POSITION := Vector2(-1.0, -1.0)
const MAX_POSITION := Vector2(1.0, 1.0)

var deep_space_immersion: Node3D
var camera_rectangle: TextureRect
var hud: Node
var camera: Camera3D
var tracking_mode := Mode.KEYS
var tracking_position := Vector2()
var tracking_image: Image
var tracking_color := Color.BLACK
var tracking_threshold := Vector3(0.1, 0.1, 0.1)
var ray_cast: RayCast3D
var junks: Node3D
var blobs: Node3D
var score: Node
var time: Node
var settings: Node


func add_hud_element(node: Node2D) -> void:
	if hud:
		hud.add_child(node)


func set_tracking_position(v: Vector2) -> void:
	var clipped := v.clamp(MIN_POSITION, MAX_POSITION)
	if tracking_position.distance_to(clipped) > DISTANCE:
		tracking_position = clipped
		emit_tracking_position_updated.call_deferred(tracking_position)


func emit_tracking_position_updated(tracking_position: Vector2) -> void:
	tracking_position_updated.emit(tracking_position)


func set_masked_image(masked_image: Image) -> void:
	emit_masked_image_updated.call_deferred(masked_image)


func emit_masked_image_updated(masked_image) -> void:
	masked_image_updated.emit(masked_image)


func set_tracking_mode(mode: Mode) -> void:
	tracking_mode = mode
	if mode == Mode.KEYS:
		set_tracking_position(Vector2())


func restart() -> void:
	deep_space_immersion.restart()


func emit_game_over() -> void:
	game_over.emit()


func emit_show_help(visible: bool) -> void:
	show_help.emit(visible)


func emit_frame_changed() -> void:
	frame_changed.emit()


func emit_frame_changed_deferred() -> void:
	emit_frame_changed.call_deferred()


func on_sphere(rng: RandomNumberGenerator, radius: float = 1.0) -> Vector3:
	return Vector3(rng.randfn(), rng.randfn(), rng.randfn()).normalized() * radius
