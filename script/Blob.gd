extends Node3D

var speed: Vector3
var life: float


func _ready() -> void:
	var scale_tween: Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	scale_tween.tween_property(self, "scale", Vector3(), life)
	scale_tween.finished.connect(die)
	var position_tween: Tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	position_tween.tween_property(self, "position", position + speed, life)


func die() -> void:
	if not is_queued_for_deletion():
		queue_free()
