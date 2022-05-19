extends Node2D

const OFFSET = Vector2(0, 32)

var target
var shield: TextureProgressBar
var repair_time: TextureProgressBar


func _ready() -> void:
	shield = $Shield
	repair_time = $RepairTime


func _process(_delta: float) -> void:
	update()


func update() -> void:
	repair_time.visible = target.in_repair
	repair_time.value = target.repair_time / target.FULL_REPAIR_TIME
	shield.visible = not target.in_repair and target.shield < target.FULL_SHIELD
	shield.value = target.shield / target.FULL_SHIELD
	position = Global.camera.unproject_position(target.position) + OFFSET
