extends CheckButton


func _ready() -> void:
	var _ignore = toggled.connect(set_settings_visible)
	Global.settings.visible = false


func set_settings_visible(b: bool) -> void:
	Global.settings.set_visible(b)
