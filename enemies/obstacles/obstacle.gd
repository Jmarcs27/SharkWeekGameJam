class_name Obstacle extends Node2D

@export var moveSpeed = 200
@export var powerUpChance = .1
@export var hitPoints = 3;

var powerUps = [
	preload("res://world/power_ups/scene/chomp_up.tscn"),
	preload("res://world/power_ups/scene/attack_speed_up.tscn"),
	preload("res://world/power_ups/scene/health_up.tscn"),
	preload("res://world/power_ups/scene/move_speed_up.tscn"),
	preload("res://world/power_ups/scene/multi_shot.tscn")
	]
	
func damage_check(area: Area2D):
	if area.is_in_group("Bullet"):
		hitPoints -= 1
		if hitPoints <= 0:
			kill()

func kill():
	randomize()
	var position = global_position
	var rand = randf();
	if(powerUpChance >= rand):
		spawn_power_up(position)
	queue_free()

func spawn_power_up(position: Vector2):
	var powerUp = powerUps.pick_random().instantiate()
	powerUp.global_position = position
	get_parent().add_child(powerUp)
