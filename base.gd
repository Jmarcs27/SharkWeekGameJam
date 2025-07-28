extends Node

var screenSize
var shork
var doubleShotPwUp
var moveSpeedPwUp
var atkSpeedPwUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shork = preload("res://player/shork.tscn")
	doubleShotPwUp = preload("res://world/double_shot.tscn")
	moveSpeedPwUp = preload("res://world/move_speed_up.tscn")
	atkSpeedPwUp = preload("res://world/attack_speed_up.tscn")
	
	var newShork = shork.instantiate()
	newShork.position = Vector2(25, 250)
	
	var doubleShot = doubleShotPwUp.instantiate()
	doubleShot.position = Vector2(700, 400)
	
	var moveSpeedUp = moveSpeedPwUp.instantiate()
	moveSpeedUp.position = Vector2(300, 600)
	
	var atkSpeedUp = atkSpeedPwUp.instantiate()
	atkSpeedUp.position = Vector2(1000, 200)
	
	add_child(newShork)
	add_child(doubleShot)
	add_child(moveSpeedUp)
	add_child(atkSpeedUp)
