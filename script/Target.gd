extends CharacterBody3D

signal died()

const FULL_SHIELD := 3.0
const FULL_REPAIR_TIME := 3.0

# TODO change to const/preload after fixing #56343
var ShieldStatus: PackedScene
var Junk: PackedScene
var shield := 3.0
var time_to_die := 30.0
var repair_time := 0.0
var in_repair := false
var shield_status
var speed := 0.0
var immune := false


func _ready() -> void:
	ShieldStatus = load("res://scene/ShieldStatus.tscn")
	add_shield()
	scale = Vector3.ONE * 0.01
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3.ONE, 1.0)


func add_shield() -> void:
	shield_status = ShieldStatus.instantiate()
	shield_status.target = self
	Global.add_hud_element(shield_status)


func _input_event(_camera: Camera3D, event: InputEvent, location: Vector3, normal: Vector3, _shape_idx: int) -> void:
	if immune:
		return
	if event is InputEventMouseButton and event.pressed:
		if shield <= 0.0:
			Global.score.add(10)
			die()
		else:
			shield -= 1.0
			if shield <= 0.0:
				in_repair = true
				repair_time = FULL_REPAIR_TIME
		shield_status.update()
		Global.blobs.add(location, normal)


func _process(delta: float) -> void:
	time_to_die -= delta
	if time_to_die <= 0.0:
		die()
	if in_repair:
		repair_time = max(repair_time - delta, 0.0)
		if repair_time <= 0.0:
			in_repair = false
			shield = FULL_SHIELD
	else:
		shield = min(shield + delta, FULL_SHIELD)
	shield_status.update()


func die() -> void:
	remove()
	explode()


func remove() -> void:
	if not is_queued_for_deletion():
		queue_free()
		shield_status.queue_free()
		emit_signal("died")


func explode() -> void:
	var junk = Junk.instantiate()
	junk.global_transform = global_transform
	Global.junks.add(junk, -transform.basis.z * speed * 0.5)
