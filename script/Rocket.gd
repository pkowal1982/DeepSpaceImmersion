extends "res://script/Target.gd"

const DEEP_SPACE = 30.0
# TODO change to const/preload after fixing #56343
var RocketJunk: PackedScene

var tween: Tween


func _ready() -> void:
	super._ready()
	RocketJunk = load("res://gltf/RocketJunk.gltf")
	Global.game_over.connect(on_game_over)
	Junk = RocketJunk


func _physics_process(_delta: float) -> void:
	velocity = -transform.basis.z * speed
	move_and_slide()
	if position.length() >= DEEP_SPACE and not tween:
		tween = create_tween()
		tween.tween_property(self, "scale", Vector3.ONE * 0.01, 1.0)
		tween.finished.connect(super_remove)


func super_remove() -> void:
	remove()


func on_game_over() -> void:
	immune = true
