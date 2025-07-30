extends Node

var screenSize
var shork
var multiShotPwUp
var moveSpeedPwUp
var atkSpeedPwUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shork = preload("res://player/shork.tscn")
	multiShotPwUp = preload("res://world/power_ups/scene/multi_shot.tscn")
	moveSpeedPwUp = preload("res://world/power_ups/scene/move_speed_up.tscn")
	atkSpeedPwUp = preload("res://world/power_ups/scene/attack_speed_up.tscn")
	
	var newShork = shork.instantiate()
	newShork.position = Vector2(25, 250)
	
	var multiShot = multiShotPwUp.instantiate()
	multiShot.position = Vector2(700, 400)
	
	var moveSpeedUp = moveSpeedPwUp.instantiate()
	moveSpeedUp.position = Vector2(300, 600)
	
	var atkSpeedUp = atkSpeedPwUp.instantiate()
	atkSpeedUp.position = Vector2(1000, 200)
	
	add_child(newShork)
	add_child(multiShot)
	add_child(moveSpeedUp)
	add_child(atkSpeedUp)
