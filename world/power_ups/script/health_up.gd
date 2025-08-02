class_name HealthUp extends PowerUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func apply(shork: Shork):
	if(shork.hitPoints < 3):
		shork.hitPoints += 1
	queue_free()
