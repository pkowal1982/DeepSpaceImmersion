extends ItemList

var selected := -1
var ids := []


func _ready() -> void:
	for device in Input.get_connected_joypads():
		on_joy_connection_changed(device)
	var _ignore = Input.joy_connection_changed.connect(self.on_joy_connection_changed)
	if item_count > 0:
		selected = 0


func _process(_delta: float) -> void:
	if Global.tracking_mode == Global.Mode.JOYSTICK and selected != -1:
		var left: bool = Global.settings.left.button_pressed
		var horizontal := Input.get_joy_axis(selected, JOY_AXIS_LEFT_X if left else JOY_AXIS_RIGHT_X)
		var vertical := Input.get_joy_axis(selected, JOY_AXIS_LEFT_Y if left else JOY_AXIS_RIGHT_Y)
		Global.set_tracking_position(Vector2(horizontal, vertical))


func on_joy_connection_changed(device: int, connected = true) -> void:
	if connected:
		var _ignore = add_item(Input.get_joy_name(device))
		ids.append(device)
	else:
		var index := ids.find(device)
		remove_item(index)
		ids.remove_at(index)
		if selected == device:
			selected = -1
