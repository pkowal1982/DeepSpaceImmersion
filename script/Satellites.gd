extends Node3D

const MAX_SATELLITES := 10

# TODO change to const/preload after fixing #56343
var Satellite: PackedScene
var SatelliteScript: Script
var rng := RandomNumberGenerator.new()
var satellite_count := 0
var time_to_deploy := 1.0


func _ready() -> void:
	Satellite = load("res://gltf/Satellite.gltf")
	SatelliteScript = load("res://script/Satellite.gd")
	rng.randomize()
	Satellite = load("res://gltf/Satellite.gltf")
	SatelliteScript = load("res://script/Satellite.gd")
	Global.game_over.connect(on_game_over)


func _process(delta) -> void:
	time_to_deploy -= delta
	if satellite_count < MAX_SATELLITES and time_to_deploy <= 0.0:
		add_satellite()


func add_satellite() -> void:
	var location := inner_space()
	if is_obscured(location):
		deploy_satellite(location)


func deploy_satellite(location: Vector3) -> void:
	var satellite = Satellite.instantiate()
	satellite.set_script(SatelliteScript)
	satellite.rotation = random_rotation()
	satellite.position = location
	add_child(satellite)
	satellite.died.connect(on_satellite_died)
	satellite_count += 1
	time_to_deploy = 1.0


func is_obscured(location: Vector3) -> bool:
	var ray_cast: RayCast3D = Global.ray_cast
	ray_cast.position = location
	ray_cast.target_position = Global.camera.global_transform.origin - location
	ray_cast.force_raycast_update()
	return ray_cast.is_colliding() and location.distance_to(ray_cast.get_collision_point()) > 1.0


func on_satellite_died() -> void:
	satellite_count -= 1


func random_rotation() -> Vector3:
	return Vector3(rng.randf(), rng.randf(), rng.randf()) * 2 * PI


func inner_space() -> Vector3:
	return Vector3(rng.randf_range(-18, 18), rng.randf_range(-9, 9), rng.randf_range(0, -10))


func on_game_over() -> void:
	set_process(false)
