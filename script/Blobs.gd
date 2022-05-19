extends Node3D

# TODO change to const/preload after fixing #56343
var Blob: PackedScene
var BlobScript: Script

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	Blob = load("res://gltf/Blob.gltf")
	BlobScript = load("res://script/Blob.gd")
	Global.blobs = self
	Blob = load("res://gltf/Blob.gltf")
	BlobScript = load("res://script/Blob.gd")
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
