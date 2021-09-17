extends RigidDynamicBody3D

var immune := false
var key := 0

func _ready() -> void:
	Global.game_over.connect(on_game_over)


func _input_event(_camera: Camera3D, event: InputEvent, location: Vector3, normal: Vector3, _shape_idx: int) -> void:
	if immune:
		return
	if event is InputEventMouseButton and event.pressed:
		Global.score.add(Global.junks.get_score(key))
		Global.blobs.add(location, normal)
		die()


func die() -> void:
	if not is_queued_for_deletion():
		queue_free()


func on_game_over() -> void:
	immune = true
