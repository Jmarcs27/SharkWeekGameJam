extends StaticBody2D

@export var moveSpeed = 200
var hitPoints = 5;

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO 
	velocity.x -= 1.0
	position += velocity * delta * moveSpeed
	
	if position.x <= 100:
		print("Deleting Mine")
		queue_free()   

func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Mine touched by ", area.name)
	if area.name == "ShorkProjectile":
		hitPoints -= 1
		print("Mine Hit! HP Reamining: ", hitPoints)
		if hitPoints <= 0:
			kill_mine()
			
func kill_mine():
	var position = transform
	# TODO: spawn power ups
	
	queue_free()
