extends Label

var score: int


func _ready() -> void:
	Global.score = self
	reset()


func reset() -> void:
	score = 0
	add(0)


func add(points: int) -> void:
	score += points
	set_text(str("Score: ", score))
