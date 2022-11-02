extends CanvasLayer

# TODO change to const/preload after fixing #56343
var cross_hair: Texture2D
var cross_hair_zoomed: Texture2D
var zoomed := true


func _ready() -> void:
	Global.hud = self
	cross_hair = load("res://image/CrossHair.png")
	cross_hair_zoomed = load("res://image/CrossHairZoomed.png")
	zoom(false)
	var _ignore = Global.tracking_position_updated.connect(on_tracking_position_updated)


func on_tracking_position_updated(_tracking_position: Vector2) -> void:
	for child in get_children():
		if child.has_method("update"):
			child.update()


func _input(event) -> void:
	if event is InputEventKey and event.keycode == KEY_T:
		Engine.time_scale = 0.1 if event.pressed else 1.0


func zoom(_zoomed = true) -> void:
	if zoomed != _zoomed:
		zoomed = _zoomed
		var cursor: Texture2D = cross_hair_zoomed if zoomed else cross_hair
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_CROSS, cursor.get_size() / 2.0)
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
