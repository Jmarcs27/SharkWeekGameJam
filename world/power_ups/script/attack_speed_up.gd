extends PowerUp

class_name AtkSpeedUp
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()

func apply(shork: Shork):
	shork.attackSpeed *= shork.atkSpeedDelta
	queue_free()
