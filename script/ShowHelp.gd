extends CheckButton


func _ready() -> void:
	toggled.connect(Global.emit_show_help)
	Global.show_help.connect(set_pressed_no_signal)
