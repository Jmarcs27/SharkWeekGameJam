extends Node

var screenSize
var shork
var powerUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shork = preload("res://player/shork.tscn")
	powerUp = preload("res://world/double_shot.tscn")
	
	var newShork = shork.instantiate()
	newShork.position = Vector2(25, 250)
	
	var newPowerUp = powerUp.instantiate()
	newPowerUp.position = Vector2(700, 400)
	
	add_child(newShork)
	add_child(newPowerUp)
