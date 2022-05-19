extends CanvasLayer

# TODO change to const/preload after fixing #56343
var CrossHair: Resource


func _ready() -> void:
	CrossHair = load("res://image/CrossHair.png")
	Global.hud = self
	var cross_hair := load("res://image/CrossHair.png")
	Input.set_custom_mouse_cursor(cross_hair, Input.CURSOR_CROSS, Vector2(16, 16))
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	Global.tracking_position_updated.connect(on_tracking_position_updated)


func on_tracking_position_updated(_tracking_position: Vector2) -> void:
	for child in get_children():
		if child.has_method("update"):
			child.update()


func _input(event) -> void:
	if event is InputEventKey and event.keycode == KEY_T:
		Engine.time_scale = 0.1 if event.pressed else 1.0
