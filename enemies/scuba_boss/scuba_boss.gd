extends Node

@export var bossBaseHealth = 120
@export var shootPercent = 0.75 # Chance for harpoon to shoot
@onready var player = get_node("../Shork")
@onready var harpoonTimer = get_child(Children.TIMER)
var harpoonScene = preload("res://enemies/scuba_boss/harpoon.tscn")

enum Phase {HEALTHY, DAMAGED, DYING, DEAD}
enum Children {HARPOONS, SPRITE, TIMER, LOCATIONS}
#enum Children {SPRITE, HARPOONS, TIMER, LOCATIONS}
var bossHealth = bossBaseHealth
var combatPhase = Phase.HEALTHY
var shootHarpoons = true

func _physics_process(delta: float):
	# TODO: Add bubbles around regulator to simulate breathing
	# TODO: Add anchors falling from above
	if(shootHarpoons):
		shoot_harpoons()
		shootHarpoons = false
		harpoonTimer.start()
	
	if (combatPhase == Phase.DAMAGED):
		damaged_phase(delta)
	elif (combatPhase == Phase.DYING):
		dying_phase(delta)
	# TODO: Disable mechs during phase change animations and death animations

func damaged_phase(delta: float):
	# TODO: Add lasers from mask
	pass

func dying_phase(delta: float):
	# TODO: Add multi-laser based on mask cracks
	# TODO: Add toxic bubbles
	pass

func shoot_harpoons():
	print("Harpoon Firing Sequence Initiated")
	for location in get_child(Children.LOCATIONS).get_children():
		var harpoon = harpoonScene.instantiate()
		harpoon.transform = location.transform
		get_child(Children.HARPOONS).add_child(harpoon)
		
	# Gets all harpoons in the fight and shoots them at the player
	for child in get_child(Children.HARPOONS).get_children():
		if (randf() <= shootPercent): # Chance to fail
			child.prepare_shot()
			await get_tree().create_timer(0.3).timeout

# Player has shot the boss
func _on_collision_zone_area_entered(area):
	bossHealth -= 1
	print("PP Boss hit. New boss HP: ", bossHealth)
	if (combatPhase == Phase.HEALTHY and bossHealth <= (bossBaseHealth * 2/3)):
		print("Boss has entered the Damaged Phase")
		combatPhase = Phase.DAMAGED
		#TODO: Add phase change effect/animation
	elif (combatPhase == Phase.DAMAGED and bossHealth <= (bossBaseHealth / 3)):
		print("Boss has entered the Dying Phase")
		combatPhase = Phase.DYING
		#TODO: Add phase change effect/animation
	elif (bossHealth <= 0):
		print("Boss has entered the Dead Phase")
		combatPhase = Phase.DEAD
		queue_free()
		#TODO: Add death animation
	# Clean up
	if (area != null):
		area.queue_free()

# Signal to shoot harpoons
func _on_timer_timeout():
	for child in get_child(Children.HARPOONS).get_children():
		child.queue_free()
	shootHarpoons = true
