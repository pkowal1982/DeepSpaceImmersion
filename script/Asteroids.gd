extends Node3D

const OUTER_SPACE := Vector3.RIGHT * 25

# TODO change to const/preload after fixing #56343
var ASTEROIDS: Array

var rng := RandomNumberGenerator.new()
var asteroids = []
var places = []

func _ready() -> void:
	for i in range(1, 8):
		ASTEROIDS.append(load(str("res://gltf/Asteroid", i, ".gltf")))
	rng.randomize()
	for i in range(0, 100):
		var place := inner_space()
		if is_too_close(place):
			continue
		add_asteroid(place)
		if places.size() > 50:
			break


func is_too_close(place: Vector3) -> bool:
	for p in places:
		if place.distance_to(p) < 3:
			return true
	return false


func add_asteroid(place: Vector3) -> void:
	places.append(place)
	var asteroid: Node3D = ASTEROIDS[rng.randi_range(0, ASTEROIDS.size() - 1)].instantiate()
	asteroid.position = place
	asteroid.rotation = random_rotation()
	add_child(asteroid)


func random_rotation() -> Vector3:
	return Vector3(rng.randf(), rng.randf(), rng.randf()) * 2 * PI


func inner_space() -> Vector3:
	var result := Vector3(rng.randf_range(-18, 18), rng.randf_range(-9, 9), rng.randf_range(0, -10))
	return result
