extends TextureRect

signal color_selected(example)


func _ready() -> void:
	Global.camera_rectangle = self


func _gui_input(event) -> void:
	if event is InputEventMouseButton and event.is_pressed:
		var example: Color = get_texture().get_image().get_pixelv(event.position)
		var _ignore = emit_signal("color_selected", example)
