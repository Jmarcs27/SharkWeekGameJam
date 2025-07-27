extends Area2D

@export var speed = 1600 # How fast the player will move (pixels/sec).
var screenSize # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var velocity = Vector2.ZERO # The player's movement vector.
	velocity.x += 1
	
	position += velocity * delta * speed
	position = position.clamp(Vector2.ZERO, screenSize)
