extends Node3D

const DeepSpace: PackedScene = preload("res://scene/DeepSpace.tscn")


func _ready() -> void:
	Global.deep_space_immersion = self


func restart() -> void:
	remove_child($DeepSpace)
	var deep_space = DeepSpace.instantiate()
	add_child(deep_space)
	move_child(deep_space, 0)


func _input(event) -> void:
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		get_tree().quit()
