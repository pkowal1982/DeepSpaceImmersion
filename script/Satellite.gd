extends "res://script/Target.gd"

const SatelliteJunk: PackedScene = preload("res://gltf/SatelliteJunk.gltf")


func _ready() -> void:
	super._ready()
	var _ignore = Global.game_over.connect(on_game_over)
	Junk = SatelliteJunk


func on_game_over() -> void:
	immune = true
	set_process(false)
