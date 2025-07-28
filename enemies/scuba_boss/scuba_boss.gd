extends Node

var player
var bossBaseHealth = 30
var bossHealth = bossBaseHealth
enum {HEALTHY, DAMAGED, DYING, DEAD}
var combatPhase = HEALTHY

func _ready():
	player = get_node("../Shork")

func _physics_process(delta: float):
	#TODO: Add bubbles around regulator to simulate breathing
	#TODO: harpoon shooting (present in all phases)
	if (combatPhase == HEALTHY):
		healthy_phase(delta)
	elif (combatPhase == DAMAGED):
		damaged_phase(delta)
	else:
		dying_phase(delta)
	# TODO: Disable mechs during phase change animations and death animations

func healthy_phase(delta: float):
	pass

func damaged_phase(delta: float):
	pass

func dying_phase(delta: float):
	pass


func _on_collision_zone_area_entered(area):
	bossHealth -= 1
	print("PP Boss hit. New boss HP: ", bossHealth)
	if (combatPhase == HEALTHY and bossHealth <= (bossBaseHealth * 2/3)):
		print("Boss has entered the Damaged Phase")
		combatPhase = DAMAGED
		#TODO: Add phase change effect/animation
	elif (combatPhase == DAMAGED and bossHealth <= (bossBaseHealth / 3)):
		print("Boss has entered the Dying Phase")
		combatPhase = DYING
		#TODO: Add phase change effect/animation
	elif (bossHealth <= 0):
		print("Boss has entered the Dead Phase")
		combatPhase = DEAD
		#TODO: Add death animation
	# Clean up
	if (area != null):
		area.queue_free()
