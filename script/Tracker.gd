extends Node

var hsv_tracker := HsvTracker.new()
var marker_tracker := MarkerTracker.new()
var marker: Image
var mutex = Mutex.new()
var semaphore = Semaphore.new()
var thread := Thread.new()
var stop_tracking := false
var previous_position := Vector3(-1, -1, -1)


func _ready() -> void:
	var marker_texture = load("res://image/marker.png")
	marker = marker_texture.get_image()
	marker.convert(Image.FORMAT_L8)

	thread.start(_thread_function)
	
	Global.frame_changed.connect(on_new_frame)


func _thread_function(_unused) -> void:
	while true:
		semaphore.wait()
		mutex.lock()
		var should_exit = stop_tracking
		mutex.unlock()
		if should_exit:
			break
		track_image()


func on_new_frame() -> void:
	if Global.tracking_mode == Global.IDLE:
		return
	semaphore.post()


func track_image() -> void:
	var texture: Texture = Global.camera_rectangle.get_texture()
	var image: Image = texture.get_image()
	var v := Vector2(-1, -1)
	match Global.tracking_mode:
		Global.HSV_MASK:
			var masked_image = Image.new()
			v = hsv_tracker.track(image, Global.tracking_color, Global.tracking_threshold, masked_image)
			Global.set_masked_image(masked_image)
		Global.HSV_TRACK:
			v = hsv_tracker.track(image, Global.tracking_color, Global.tracking_threshold)
		Global.MARKER_TRACK:
			image.convert(Image.FORMAT_L8)
			previous_position = marker_tracker.track(image, previous_position)
			v = Vector2(previous_position.x, previous_position.y)
	if v != Vector2(-1, -1):
		Global.set_tracking_position(v / image.get_size() - Vector2.ONE * 0.5)
	pass


func _exit_tree() -> void:
	mutex.lock()
	stop_tracking = true
	mutex.unlock()
	semaphore.post()
	thread.wait_to_finish()
