extends "res://script/Target.gd"

const RocketJunk: PackedScene = preload("res://gltf/RocketJunk.gltf")
const DEEP_SPACE = 30.0

var tween: Tween


func _ready() -> void:
	super._ready()
	var _ignore = Global.game_over.connect(on_game_over)
	Junk = RocketJunk


func _physics_process(_delta: float) -> void:
	velocity = -transform.basis.z * speed
	var _ignore = move_and_slide()
	if position.length() >= DEEP_SPACE and not tween:
		tween = create_tween()
		_ignore = tween.tween_property(self, "scale", Vector3.ONE * 0.01, 1.0)
		_ignore = tween.finished.connect(super_remove)


func super_remove() -> void:
	remove()


func on_game_over() -> void:
	immune = true
