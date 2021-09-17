extends Node3D

const JunkScript: Script = preload("res://script/Junk.gd")

var rng := RandomNumberGenerator.new()
var scores := {}
var actual_hash := 0

func _ready() -> void:
	Global.junks = self
	rng.randomize()


func add(node: Node3D, speed = Vector3()) -> void:
	add_child(node)
	actual_hash += 1
	for child in node.get_children():
		if child is RigidDynamicBody3D:
			var junk: RigidDynamicBody3D = child
			junk.set_script(JunkScript)
			junk.request_ready()
			junk.key = actual_hash
			var junk_global_transform := junk.global_transform
			node.remove_child(junk)
			add_child(junk)
			junk.global_transform = junk_global_transform
			junk.apply_impulse(speed)
			junk.apply_impulse(Global.on_sphere(rng, 0.5), Global.on_sphere(rng))
	node.queue_free()


func get_score(key: int) -> int:
	if not scores.has(key):
		scores[key] = 0
	scores[key] += 1
	return scores[key]
