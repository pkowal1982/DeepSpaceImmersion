extends Node3D

const OUTER_SPACE := Vector3.RIGHT * 25
const MAX_ROCKETS := 10

var Rocket: PackedScene
var RocketScript: Resource

var rng := RandomNumberGenerator.new()
var rocket_count := 0
var time_to_launch := 1.0


func _ready() -> void:
	rng.randomize()
	Rocket = load("res://gltf/Rocket.gltf")
	RocketScript = load("res://script/Rocket.gd")
	Global.game_over.connect(on_game_over)


func _process(delta) -> void:
	time_to_launch -= delta
	if rocket_count < MAX_ROCKETS and time_to_launch <= 0.0:
		add_rocket()


func add_rocket() -> void:
	var from_angle := rng.randf() * 2 * PI
	var to_angle := from_angle + 0.667 * PI * (1 + rng.randf())
	var from_depth := rng.randf() * 10
	var to_depth :=  rng.randf() * 10
	var from_outer_space := outer_space(from_angle, from_depth)
	var to_outer_space := outer_space(to_angle, to_depth)
	if is_empty_trajectory(from_outer_space, to_outer_space):
		launch_rocket(from_outer_space, to_outer_space)


func outer_space(angle: float, depth: float) -> Vector3:
	return OUTER_SPACE.rotated(Vector3.FORWARD, angle) + Vector3.FORWARD * depth


func is_empty_trajectory(from: Vector3, to: Vector3) -> bool:
	var ray_cast := Global.ray_cast
	ray_cast.position = from
	ray_cast.target_position = to - from
	ray_cast.force_raycast_update()
	return not ray_cast.is_colliding()


func launch_rocket(from: Vector3, to: Vector3) -> void:
	var rocket = Rocket.instantiate()
	rocket.set_script(RocketScript)
	rocket.position = from
	rocket.speed = rng.randf_range(1.0, 3.0)
	add_child(rocket)
	rocket.look_at(to)
	rocket.died.connect(on_rocket_died)
	rocket_count += 1
	time_to_launch = 2.0


func on_rocket_died() -> void:
	rocket_count -= 1


func on_game_over() -> void:
	set_process(false)
	for rocket in get_children():
		rocket.set_process_input(false)
