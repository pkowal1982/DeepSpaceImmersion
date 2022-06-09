extends Node

signal tracking_position_updated(tracking_position)
signal masked_image_updated(masked_image)
signal game_over()
signal show_help(visible)
signal frame_changed()

enum { KEYS, HSV_TRACK, HSV_MASK, MARKER_TRACK, JOYSTICK }

const DISTANCE := 0.01
const MIN_POSITION := Vector2(-1.0, -1.0)
const MAX_POSITION := Vector2(1.0, 1.0)

var deep_space_immersion: Node3D
var camera_rectangle: TextureRect
var hud: Node
var camera: Camera3D
var tracking_mode := KEYS
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
		emit_signal("tracking_position_updated", tracking_position)


func set_masked_image(masked_image: Image) -> void:
	emit_signal("masked_image_updated", masked_image)


func set_tracking_mode(mode: int) -> void:
	tracking_mode = mode
	if mode == KEYS:
		set_tracking_position(Vector2())


func restart() -> void:
	deep_space_immersion.restart()


func emit_game_over() -> void:
	emit_signal("game_over")


func emit_show_help(visible: bool) -> void:
	emit_signal("show_help", visible)


func emit_frame_changed() -> void:
	emit_signal("frame_changed")


func on_sphere(rng: RandomNumberGenerator, radius: float = 1.0) -> Vector3:
	return Vector3(rng.randfn(), rng.randfn(), rng.randfn()).normalized() * radius
