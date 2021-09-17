extends Node3D


func _ready() -> void:
	Global.game_over.connect(on_game_over)


func on_game_over() -> void:
	var game_over: Label =  $GameOver
	game_over.set_text("Game Over\nScore: %d\nJunks left: %d" % [Global.score.score, $Junks.get_child_count()])
	game_over.visible = true
