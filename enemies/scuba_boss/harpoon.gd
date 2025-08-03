extends Node2D

@export var shootSpeed = 300
# Used for children indexing
enum {BOLT, HARPOON}
@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var bolt = get_child(BOLT)
@onready var harpoon = get_child(HARPOON)
@onready var audioManager = get_tree().get_nodes_in_group("AudioManager")[0]

var boltDir : Vector2 = Vector2.LEFT
var aiming = false
var shooting = false

func _physics_process(delta: float):
	if (shooting):
		bolt.translate(boltDir * delta * shootSpeed)
	elif (aiming == true):
		# Rotates the harpoon toward the player
		if (player == null): print("Player null")
		var direction = (player.global_position - bolt.global_position).normalized()
		var direction2 = (player.global_position + bolt.global_position).normalized()
		var target_angle = direction.angle() - PI
		bolt.rotation = target_angle
		harpoon.rotation = target_angle
		boltDir = (player.global_position - bolt.global_position).normalized()
	pass
	
func prepare_shot(fromBoss: bool) -> void:
	aiming = true # Enables player tracking
	if fromBoss:
		# Uses tween to animate the harpoons appearing from behind the boss
		var tween = create_tween()
		tween.tween_property(self, "position", position - Vector2(84, 0), 2)
		# Waits for tween to end and shoots the bolt
	await get_tree().create_timer(2.5).timeout
	shooting = true
	audioManager.get_node("HarpoonShot").play()
	reload(fromBoss)
	
# Hides the harpoon for cleanup
func reload(fromBoss: bool) -> void:
	if fromBoss:
		var tween = create_tween()
		tween.tween_property(harpoon, "position", harpoon.position + Vector2(84, 0), 2)
	
