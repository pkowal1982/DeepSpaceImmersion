extends Node3D

# TODO change to const/preload after fixing #56343
var JunkScript: Script

var rng := RandomNumberGenerator.new()
var scores := {}
var actual_hash := 0

func _ready() -> void:
	JunkScript = load("res://script/Junk.gd")
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
			junk.score_hash = actual_hash
			var junk_global_transform := junk.global_transform
			node.remove_child(junk)
			add_child(junk)
			junk.global_transform = junk_global_transform
			junk.apply_impulse(speed)
			junk.apply_impulse(Global.on_sphere(rng, 0.5), Global.on_sphere(rng))
	node.queue_free()


func get_score(score_hash: int) -> int:
	if not scores.has(score_hash):
		scores[score_hash] = 0
	scores[score_hash] += 1
	return scores[score_hash]
