extends StaticBody2D

@export var moveSpeed = 200

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO 
	velocity.x -= 1.0
	position += velocity * delta * moveSpeed
	
	if position.x <= 100:
		print("Deleting Mine")
		queue_free()   
