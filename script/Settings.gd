extends Node

var cameras: ItemList
var camera_rectangle: TextureRect
var masked_rectangle: TextureRect
var camera_texture: CameraTexture
var color_picker_button: ColorPickerButton
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
	var _ignore = keys.pressed.connect(on_tracking_mode_changed.bind(Global.Mode.KEYS))
	_ignore = hsv_track.pressed.connect(on_tracking_mode_changed.bind(Global.Mode.HSV_TRACK))
	_ignore = hsv_mask.pressed.connect(on_tracking_mode_changed.bind(Global.Mode.HSV_MASK))
	_ignore = marker_track.pressed.connect(on_tracking_mode_changed.bind(Global.Mode.MARKER_TRACK))
	_ignore = joystick.pressed.connect(on_tracking_mode_changed.bind(Global.Mode.JOYSTICK))
	var left_right_button_group := ButtonGroup.new()
	left.set_button_group(left_right_button_group)
	right.set_button_group(left_right_button_group)
	left.button_pressed = true

	_ignore = hue.value_changed.connect(on_threshold_changed)
	_ignore = saturation.value_changed.connect(on_threshold_changed)
	_ignore = value.value_changed.connect(on_threshold_changed)

	_ignore = color_picker_button.color_changed.connect(on_color_changed)
	_ignore = camera_rectangle.color_selected.connect(on_color_selected)
	camera_texture = camera_rectangle.get_texture()

	_ignore = cameras.item_selected.connect(change_feed)
	_ignore = CameraServer.camera_feed_added.connect(update_cameras)
	_ignore = CameraServer.camera_feed_removed.connect(update_cameras)
	update_cameras(-1)
	
	_ignore = Global.tracking_position_updated.connect(on_tracking_position_updated)
	_ignore = Global.masked_image_updated.connect(on_masked_image_updated)
	on_tracking_mode_changed(Global.Mode.KEYS)


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
	color_picker_button = $Columns/Column2/ColorPicker


func update_cameras(_unused: int) -> void:
	cameras.clear()
	if CameraServer.get_feed_count() > 0:
		for index in range(0, CameraServer.get_feed_count()):
			var camera_feed: CameraFeed = CameraServer.get_feed(index)
			var _ignore = cameras.add_item(camera_feed.get_name())
		change_feed(0)


func change_feed(index: int) -> void:
	if selected_camera_feed:
		selected_camera_feed.set_active(false)
		selected_camera_feed.frame_changed.disconnect(Global.emit_frame_changed_deferred)
	selected_camera_feed = CameraServer.get_feed(index)
	set_format(selected_camera_feed)
	selected_camera_feed.set_active(true)
	var _ignore = selected_camera_feed.frame_changed.connect(Global.emit_frame_changed_deferred)
	camera_texture.set_camera_feed_id(selected_camera_feed.get_id())


func set_format(camera_feed: CameraFeed) -> void:
	for frame_denominator in [60, 30, 1]:
		for width in [320, 640]:
			# !!! if not marker tracking than do not try yuyv or convert to rgb?
			for format in ["YUYV", "MJPG", "JPEG"] if Global.tracking_mode == Global.Mode.MARKER_TRACK else ["MJPG", "JPEG", "YUYV"]:
				var d := {"frame_denominator": frame_denominator, "width": width, "format": format}
				if set_format_with_parameters(camera_feed, d):
					return


func set_format_with_parameters(camera_feed: CameraFeed, d: Dictionary) -> bool:
	var formats: Array = camera_feed.get_formats()
	for index in range(0, formats.size()):
		var format: Dictionary = formats[index]
		if d["width"] == format["width"] and d["frame_denominator"] == format["frame_denominator"] and d["format"] in format["format"]:
			var _ignore = camera_feed.set_format(index, {"output": "separate"} if marker_track.button_pressed else {})
			camera_rectangle.custom_minimum_size = Vector2(format["width"], format["height"])
			return true
	return false


func on_masked_image_updated(masked_image) -> void:
	var masked_texture := ImageTexture.create_from_image(masked_image)
	masked_rectangle.set_texture(masked_texture)


func on_color_changed(color: Color) -> void:
	Global.tracking_color = color


func on_color_selected(example: Color) -> void:
	color_picker_button.color = example
	Global.tracking_color = example
	# !!! not changing the mode to rgb
	Global.set_tracking_mode(Global.Mode.HSV_MASK)
	hsv_mask.set_pressed(true)


func on_threshold_changed(_unused) -> void:
	Global.tracking_threshold = Vector3(hue.value, saturation.value, value.value)


func on_tracking_mode_changed(mode: int) -> void:
	Global.set_tracking_mode(mode)
	$Cross.visible = mode == Global.Mode.HSV_MASK or mode == Global.Mode.HSV_TRACK
	$Frame.visible = mode == Global.Mode.MARKER_TRACK
	update_cameras(-1)


func on_tracking_position_updated(tracking_position: Vector2) -> void:
	$Cross.set_position((tracking_position * 0.5 + Vector2(0.5, 0.5)) * camera_texture.get_size() + camera_rectangle.global_position)
	$Frame.set_position((tracking_position * 0.5 + Vector2(0.5, 0.5)) * camera_texture.get_size() + camera_rectangle.global_position)
