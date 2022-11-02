extends Button


func _ready() -> void:
	var _ignore = button_down.connect(Global.restart)
