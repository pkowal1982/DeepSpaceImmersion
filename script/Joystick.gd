extends CheckBox


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.tracking_mode == Global.JOYSTICK:
		Global.set_tracking_position(Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"))
