class_name SeaMine extends Obstacle

func _ready() -> void:
	hitPoints = 4
	
func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO 
	velocity.x -= 1.0
	position += velocity * delta * moveSpeed
	
	if position.x <= -100:
		queue_free()   

func _on_hitbox_area_entered(area: Area2D) -> void:
	damage_check(area)
