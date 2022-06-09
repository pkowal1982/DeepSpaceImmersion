extends Node

var cameras: ItemList
var camera_rectangle: TextureRect
var masked_rectangle: TextureRect
var camera_texture: CameraTexture
var color_picker: ColorPicker
var keys: CheckBox
var hsv_track: CheckBox
var hsv_mask: CheckBox
var marker_track: CheckBox
var joystick: CheckBox
var left: CheckBox
var right: CheckBox
#var masked_texture: ImageTexture
var hue: HSlider
var saturation: HSlider
var value: HSlider
var selected_camera_feed: CameraFeed


func _ready() -> void:
	Global.settings = self

	assign_controls_to_variables()

	var button_group := ButtonGroup.new()
	keys.set_button_group(button_group)
	hsv_track.set_button_group(button_group)
	hsv_mask.set_button_group(button_group)
	marker_track.set_button_group(button_group)
	joystick.set_button_group(button_group)
	keys.set_pressed(true)
	keys.connect("pressed", on_tracking_mode_changed, [Global.KEYS])
	hsv_track.connect("pressed", on_tracking_mode_changed, [Global.HSV_TRACK])
	hsv_mask.connect("pressed", on_tracking_mode_changed, [Global.HSV_MASK])
	marker_track.connect("pressed", on_tracking_mode_changed, [Global.MARKER_TRACK])
	joystick.connect("pressed", on_tracking_mode_changed, [Global.JOYSTICK])
	var left_right_button_group := ButtonGroup.new()
	left.set_button_group(left_right_button_group)
	right.set_button_group(left_right_button_group)
	left.button_pressed = true

	hue.value_changed.connect(on_threshold_changed)
	saturation.value_changed.connect(on_threshold_changed)
	value.value_changed.connect(on_threshold_changed)

	color_picker.color_changed.connect(on_color_changed)
	camera_rectangle.color_selected.connect(on_color_selected)
	camera_texture = camera_rectangle.get_texture()

	cameras.item_selected.connect(change_feed)
	CameraServer.camera_feed_added.connect(update_cameras)
	CameraServer.camera_feed_removed.connect(update_cameras)
	update_cameras(-1)
	
	Global.tracking_position_updated.connect(on_tracking_position_updated)
	Global.masked_image_updated.connect(on_masked_image_updated)
	on_tracking_mode_changed(Global.KEYS)


func assign_controls_to_variables() -> void:
	cameras = $Columns/Column1/Cameras
	camera_rectangle = $Columns/Column1/CameraRectangle
	masked_rectangle = $Columns/Column1/MaskedRectangle
	keys = $Columns/Column2/Tracking/Keys
	hsv_track = $Columns/Column2/Tracking/HsvTrack
	hsv_mask = $Columns/Column2/Tracking/HsvMask
	marker_track = $Columns/Column2/Tracking/MarkerTrack
	joystick = $Columns/Column2/Tracking/Joystick
	left = $Columns/Column2/Joystick/Left
	right = $Columns/Column2/Joystick/Right
	hue = $Columns/Column2/Threshold/Hue
	saturation = $Columns/Column2/Threshold/Saturation
	value = $Columns/Column2/Threshold/Value
	color_picker = $Columns/Column2/ColorPicker.get_picker()


func update_cameras(_unused: int) -> void:
	cameras.clear()
	if CameraServer.get_feed_count() > 0:
		for index in range(0, CameraServer.get_feed_count()):
			var camera_feed: CameraFeed = CameraServer.get_feed(index)
			cameras.add_item(camera_feed.get_name())
		change_feed(0)


func change_feed(index: int) -> void:
	if selected_camera_feed:
		selected_camera_feed.set_active(false)
		selected_camera_feed.frame_changed.disconnect(Global.emit_frame_changed)
	selected_camera_feed = CameraServer.get_feed(index)
	set_format(selected_camera_feed)
	selected_camera_feed.set_active(true)
	selected_camera_feed.frame_changed.connect(Global.emit_frame_changed)
	camera_texture.set_camera_feed_id(selected_camera_feed.get_id())


func set_format(camera_feed: CameraFeed) -> void:
	for frame_denominator in [60, 30, 1]:
		for width in [320, 240]:
			for format in ["YUYV", "MJPG", "JPEG"]:
				var d := {"frame_denominator": frame_denominator, "width": width, "format": format}
				if set_format_with_parameters(camera_feed, d):
					return


func set_format_with_parameters(camera_feed: CameraFeed, d: Dictionary) -> bool:
	var formats: Array = camera_feed.get_formats()
	for index in range(0, formats.size()):
		var format: Dictionary = formats[index]
		if d["width"] == format["width"] and d["frame_denominator"] == format["frame_denominator"] and d["format"] in format["format"]:
			camera_feed.set_format(index, {"output": "separate"} if marker_track.button_pressed else {})
			return true
	return false


func on_masked_image_updated(masked_image) -> void:
	var masked_texture: ImageTexture = ImageTexture.new()
	masked_texture.create_from_image(masked_image)
	masked_rectangle.set_texture(masked_texture)


func on_color_changed(color: Color) -> void:
	Global.tracking_color = color


func on_color_selected(example: Color) -> void:
	color_picker.color = example
	Global.tracking_color = example
	Global.set_tracking_mode(Global.HSV_MASK)
	hsv_mask.set_pressed(true)


func on_threshold_changed(_unused) -> void:
	Global.tracking_threshold = Vector3(hue.value, saturation.value, value.value)


func on_tracking_mode_changed(mode: int) -> void:
	Global.set_tracking_mode(mode)
	$Cross.visible = mode == Global.HSV_MASK or mode == Global.HSV_TRACK
	$Frame.visible = mode == Global.MARKER_TRACK
	update_cameras(-1)


func on_tracking_position_updated(tracking_position: Vector2) -> void:
	$Cross.set_position((tracking_position * 0.5 + Vector2(0.5, 0.5)) * camera_texture.get_size() + camera_rectangle.global_position)
	$Frame.set_position((tracking_position * 0.5 + Vector2(0.5, 0.5)) * camera_texture.get_size() + camera_rectangle.global_position)
