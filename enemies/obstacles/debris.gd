class_name Debris extends Obstacle

func _ready() -> void:
	var textures = $Textures.get_children()
	hitPoints = 1
	textures.pick_random().visible = true
	
	
func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO 
	velocity.y += 1
	position += velocity * delta * moveSpeed
	
	if position.y >= 400:
		queue_free()   

func _on_hitbox_area_entered(area: Area2D) -> void:
	damage_check(area)
