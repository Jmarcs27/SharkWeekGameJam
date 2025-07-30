extends Node2D

var lastSpawnerUsed
var mineScene = preload("res://enemies/sea_mine.tscn")

func spawn_mine():
	var spawners = get_children()
	var spawner = spawners.pick_random()
	
	if lastSpawnerUsed == null:
		lastSpawnerUsed = spawner
		
	while lastSpawnerUsed == spawner:
		spawner = spawners.pick_random()
	
	var mine = mineScene.instantiate()
	mine.transform = spawner.transform
	mine.scale = Vector2(0.4, 0.4)

	get_parent().add_child(mine)
	lastSpawnerUsed = spawner

func _on_mine_spawn_timer_timeout() -> void:
	print("Spawning Mine")
	spawn_mine()
