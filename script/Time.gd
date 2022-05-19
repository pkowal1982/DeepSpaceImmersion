extends Label

var time: float


func _ready() -> void:
	Global.time = self
	reset()


func _process(delta) -> void:
	time -= delta
	if time >= 0:
		set_text("Time: %.1f" % [time])
	else:
		Global.emit_game_over()
		set_process(false)
		set_text("")


func reset() -> void:
	time = 120
	set_text("Time: %.1f" % [time])
