extends StaticBody2D

@export var moveSpeed = 200
var hitPoints = 1

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO 
	velocity.y += 1
	position += velocity * delta * moveSpeed
	
	if position.y >= 400:
		print("Deleting Debris")
		queue_free()   

func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Debris touched by ", area.name)
	if area.name == "ShorkProjectile":
		hitPoints -= 1
		print("Debris Hit! HP Reamining: ", hitPoints)
		if hitPoints <= 0:
			kill_debris()
			
func kill_debris():
	var position = transform
	# TODO: spawn power ups
	
	queue_free()
