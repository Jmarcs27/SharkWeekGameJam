class_name ChompUp extends PowerUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func apply(shork: Shork):
	shork.bombCount += 1
	queue_free()
