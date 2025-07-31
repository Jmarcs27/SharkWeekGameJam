class_name MoveSpeedUp extends PowerUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()

func apply(shork: Shork):
	shork.moveSpeed *= 1.1
	queue_free()
