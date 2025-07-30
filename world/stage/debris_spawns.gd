extends Node2D

var lastSpawnerUsed
var debrisScene = preload("res://enemies/debris.tscn")

func spawn_debris():
	var spawners = get_children()
	var spawner = spawners.pick_random()
	
	if lastSpawnerUsed == null:
		lastSpawnerUsed = spawner
		
	while lastSpawnerUsed == spawner:
		spawner = spawners.pick_random()
	
	var debris = debrisScene.instantiate()
	debris.transform = spawner.transform
	debris.scale = Vector2(0.2, 0.2)

	get_parent().add_child(debris)
	lastSpawnerUsed = spawner

func _on_debris_spawn_timer_timeout() -> void:
	print("Spawning debris")
	spawn_debris()
