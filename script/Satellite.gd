extends "res://script/Target.gd"

# TODO change to const/preload after fixing #56343
var SatelliteJunk: PackedScene


func _ready() -> void:
	SatelliteJunk = load("res://gltf/SatelliteJunk.gltf")
	super._ready()
	SatelliteJunk = load("res://gltf/SatelliteJunk.gltf")
	Global.game_over.connect(on_game_over)
	Junk = SatelliteJunk


func on_game_over() -> void:
	immune = true
	set_process(false)
