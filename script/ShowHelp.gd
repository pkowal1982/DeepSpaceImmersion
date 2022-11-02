extends CheckButton


func _ready() -> void:
	var _ignore = toggled.connect(Global.emit_show_help)
	_ignore = Global.show_help.connect(set_pressed_no_signal)
