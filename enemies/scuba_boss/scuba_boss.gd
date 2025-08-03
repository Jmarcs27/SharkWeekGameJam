extends Node

@export var bossBaseHealth = 2
@export var shootPercent = 0.75 # Chance for harpoon to shoot
@onready var player = get_node("%Shork")
var harpoonScene = preload("res://enemies/scuba_boss/harpoon.tscn")

# Defined the boss phases and set constants in a dictionary
enum {	HEALTHY, DAMAGED, DEAD, HARPOONS, HTIMER, LTIMER, SPRITE, LOCATIONS, MLASER, TLASER} 
@onready var child = {
	HARPOONS: $Harpoons,
	HTIMER: $Timers/HarpoonTimer,
	SPRITE: $boss_location,
	LOCATIONS: $HarpoonLocations,
	MLASER: $MainLaser,
	TLASER: $TopLaser
}
@onready var laserPos = child[TLASER].position

var bossHealth = bossBaseHealth
var shootHarpoons : bool = true
var bossPhasing : bool = false
var baseColor : Color = self.modulate
var laserDir = Vector2(1, 0)
var combatPhase = HEALTHY
const BG = "Bullet"

func _ready():
	set_physics_process(false)

func _physics_process(delta: float):
	# TODO: Add bubbles around regulator to simulate breathing
	if (not bossPhasing and combatPhase != DEAD):
		if(shootHarpoons):
			shoot_harpoons()
			shootHarpoons = false
			child[HTIMER].start()
	if (combatPhase == DAMAGED):
		if (child[TLASER].position.x <= 0):
			laserDir = Vector2(1, 0)
		elif(child[TLASER].position.x >= 460):
			laserDir = Vector2(-1, 0)
		child[TLASER].position += laserDir *100*delta
		
func enable_boss() -> void:

	var tween = create_tween()
	bossPhasing = true
	tween.tween_property(self, "position", Vector2 (0, 0), 3)
	await get_tree().create_timer(3.0).timeout
	set_physics_process(true)
	bossPhasing = false
	print("Boss has been enabled")

func shoot_harpoons() -> void:
	print("Harpoon Firing Sequence Initiated")
	for location in child[LOCATIONS].get_children():
		var harpoon = harpoonScene.instantiate()
		harpoon.transform = location.transform
		child[HARPOONS].add_child(harpoon)
		
	# Gets all harpoons in the fight and shoots them at the player
	for children in child[HARPOONS].get_children():
		if (randf() <= shootPercent): # Chance to fail
			if (bossPhasing or children == null): break
			children.prepare_shot(true)
			await get_tree().create_timer(0.3).timeout

func shoot_main_laser(shootTime : float):
	var tween = create_tween() # To telegraph the shot
	tween.tween_property(child[SPRITE], "modulate", Color(1, 0, 0, 1), 1)
	await get_tree().create_timer(1).timeout
	child[MLASER].set_casting(true)
	await get_tree().create_timer(shootTime).timeout
	child[MLASER].set_casting(false)
	tween = create_tween()
	tween.tween_property(child[SPRITE], "modulate", Color(1, 1, 1, 1), 0.5)
	shoot_lasers()
	
func shoot_lasers() -> void:
	return # Disabling to reduce difficulty
	#print("Firing Laser")
	#child[TLASER].set_casting(true)
	#await get_tree().create_timer(2).timeout
	#child[TLASER].set_casting(false)

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
	tween.tween_property(child[SPRITE], "modulate", Color(0, 0, 0, 1), 0.05)
	tween.tween_property(child[SPRITE], "modulate", Color(1, 1, 1, 1), 0.25)
	
	# Checks if boss has met a damage threshhold for phase change
	if (combatPhase == HEALTHY and bossHealth <= (bossBaseHealth * 1/2)):
		phase_change()
	elif (bossHealth <= 0):
		phase_change()

#### PHASE RELATED CODE ####
# For changing phases as a tween callback
func set_phasing():
	bossPhasing = !bossPhasing

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
			tween.tween_property(self, "position", Vector2 (0, -50), 3)
			shoot_main_laser(3)
			await get_tree().create_timer(3).timeout
			tween = create_tween()
			tween.tween_property(self, "position", Vector2 (0, 0), 1)
			tween.tween_callback(set_phasing) # Hides the line when tween has ended
			pass
		DAMAGED:
			print("Boss has entered the Dead Phase")
			combatPhase = DEAD
			tween.tween_property(self, "position", Vector2 (0, 400), 1)
			tween.tween_callback(queue_free)
			pass
#### PHASE RELATED CODE ####

# Signal to shoot harpoons
func _on_timer_timeout():
	for child in child[HARPOONS].get_children():
		child.queue_free()
	shootHarpoons = true

# Signal to shoot lasers
func _on_l_timer_timeout():
	if(combatPhase == DAMAGED and not bossPhasing):
		shoot_main_laser(2)
	$Timers/MainLaserTimer.start()

func _on_top_laser_timer_timeout():
	if(combatPhase == DAMAGED and not bossPhasing):
		shoot_main_laser(2)
	$Timers/TopLaserTimer.start()
