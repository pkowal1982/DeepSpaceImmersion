extends Node3D

# TODO change to const/preload after fixing #56343
var DeepSpace: PackedScene


func _ready() -> void:
	DeepSpace = load("res://scene/DeepSpace.tscn")
	Global.deep_space_immersion = self


func restart() -> void:
	remove_child($DeepSpace)
	var deep_space = DeepSpace.instantiate()
	add_child(deep_space)
	move_child(deep_space, 0)


func _input(event) -> void:
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		get_tree().quit()
