extends Node3D

const Blob: PackedScene = preload("res://gltf/Blob.gltf")
const BlobScript: Script = preload("res://script/Blob.gd")

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	Global.blobs = self
	rng.randomize()


func add(location: Vector3, _normal: Vector3) -> void:
	for i in range (0, rng.randi_range(4, 8)):
		var blob: Node3D = Blob.instantiate()
		blob.set_script(BlobScript)
		blob.position = location
		# TODO add normal handling on hemisphere
		blob.speed = Global.on_sphere(rng, randf_range(0.75, 1.25))
		blob.life = rng.randf_range(0.05, 0.3)
		blob.scale = Vector3.ONE * rng.randf_range(0.5, 1.5)
		add_child(blob)
