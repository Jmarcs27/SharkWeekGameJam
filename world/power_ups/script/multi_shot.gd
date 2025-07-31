class_name MultiShot extends PowerUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()

func apply(shork: Shork):
	shork.multiShotStacks += 1
	queue_free()
