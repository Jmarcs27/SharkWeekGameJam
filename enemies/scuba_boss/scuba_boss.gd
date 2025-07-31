extends Node

@export var bossBaseHealth = 6
@export var shootPercent = 0.75 # Chance for harpoon to shoot
@onready var player = get_node("../Shork")
var harpoonScene = preload("res://enemies/scuba_boss/harpoon.tscn")

# Defined the boss phases and set constants in a dictionary
enum {	HEALTHY, DAMAGED, DYING, DEAD, HARPOONS, TIMER, SPRITE, LOCATIONS, LASER} 
@onready var child = {
	HARPOONS: $Harpoons,
	TIMER: $Timer,
	SPRITE: $boss_location,
	LOCATIONS: $HarpoonLocations,
	LASER: $Laser,
}

var bossHealth = bossBaseHealth
var shootHarpoons : bool = true
var bossPhasing : bool = false
var combatPhase = HEALTHY
const BG = "Bullet"

func _physics_process(delta: float):
	# TODO: Add bubbles around regulator to simulate breathing
	# TODO: Add anchors falling from above
	if (not bossPhasing and combatPhase != DEAD):
		if(shootHarpoons):
			shoot_harpoons()
			shootHarpoons = false
			child[TIMER].start()
		
		if (combatPhase == DAMAGED):
			shoot_lasers()
		elif (combatPhase == DYING):
			dying_phase(delta)
		# TODO: Disable mechs during phase change animations and death animations

func damaged_phase(delta: float):
	# TODO: Add lasers from mask
	pass

func dying_phase(delta: float):
	# TODO: Add multi-laser based on mask cracks
	# TODO: Add toxic bubbles
	pass
	
func set_phasing():
	bossPhasing = !bossPhasing

func shoot_harpoons() -> void:
	print("Harpoon Firing Sequence Initiated")
	for location in child[LOCATIONS].get_children():
		var harpoon = harpoonScene.instantiate()
		harpoon.transform = location.transform
		child[HARPOONS].add_child(harpoon)
		
	# Gets all harpoons in the fight and shoots them at the player
	for child in child[HARPOONS].get_children():
		if (randf() <= shootPercent): # Chance to fail
			if (bossPhasing or child == null): break
			child.prepare_shot()
			await get_tree().create_timer(0.3).timeout

func shoot_lasers():
	pass

# Player has shot the boss
func _on_collision_zone_area_entered(area):
	if (not area.is_in_group(BG) or bossPhasing):
		if (area != null): area.queue_free()
		return
	bossHealth -= 1
	print("PP Boss hit. New boss HP: ", bossHealth)
	# Clean up
	if (area != null): area.queue_free()
	# Animates the boss taking damage
	var tween = create_tween()
	tween.tween_property(child[SPRITE], "modulate", Color(1, 0, 0, 0.9), 0.05)
	tween.tween_property(child[SPRITE], "modulate", Color(1, 1, 1, 1), 0.25)
	
	# Checks if boss has met a damage threshhold for phase change
	if (combatPhase == HEALTHY and bossHealth <= (bossBaseHealth * 2/3)):
		phase_change()
	elif (combatPhase == DAMAGED and bossHealth <= (bossBaseHealth / 3)):
		phase_change()
	elif (bossHealth <= 0):
		phase_change()

func phase_change():
	# Pre-phasing cleanup
	for harpoon in child[HARPOONS].get_children():
		harpoon.queue_free()
	var tween = create_tween()
	bossPhasing = true
	match combatPhase:
		HEALTHY:
			print("Boss has entered the Damaged Phase")
			combatPhase = DAMAGED
			tween.tween_property(self, "position", Vector2 (0, 400), 1)
			await get_tree().create_timer(1.3).timeout
			tween = create_tween()
			tween.tween_property(self, "position", Vector2 (0, -100), 3)
			shoot_lasers()
			await get_tree().create_timer(3).timeout
			tween = create_tween()
			tween.tween_property(self, "position", Vector2 (0, 0), 1)
			tween.tween_callback(set_phasing) # Hides the line when tween has ended
			pass
		DAMAGED:
			print("Boss has entered the Dying Phase")
			combatPhase = DYING
			set_phasing()
			pass
		DYING:
			combatPhase = DEAD
			queue_free()
			pass

# Signal to shoot harpoons
func _on_timer_timeout():
	for child in child[HARPOONS].get_children():
		child.queue_free()
	shootHarpoons = true
