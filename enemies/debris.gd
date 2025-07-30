extends StaticBody2D

@export var moveSpeed = 200

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO 
	velocity.y += 1
	position += velocity * delta * moveSpeed
	
	if position.y >= 400:
		print("Deleting Debris")
		queue_free()   
