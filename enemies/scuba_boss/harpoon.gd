extends Node2D

@export var shootSpeed = 300
# Used for children indexing
enum Children {BOLT, HARPOON}
@onready var player = get_node("../../../Shork")
@onready var bolt = get_child(Children.BOLT)
@onready var harpoon = get_child(Children.HARPOON)

var boltDir : Vector2 = Vector2.LEFT
var aiming = false
var shooting = false
	
func _physics_process(delta: float):
	if (shooting):
		bolt.translate(boltDir * delta * shootSpeed)
	elif (aiming == true):
		# Rotates the harpoon toward the player
		var direction = (player.global_position - bolt.global_position).normalized()
		var direction2 = (player.global_position + bolt.global_position).normalized()
		var target_angle = direction.angle() - PI
		bolt.rotation = target_angle
		harpoon.rotation = target_angle
		boltDir = (player.global_position - bolt.global_position).normalized()
	pass
	
func prepare_shot():
	aiming = true # Enables player tracking
	# Uses tween to animate the harpoons appearing from behind the boss
	var tween = create_tween()
	tween.tween_property(self, "position", position - Vector2(84, 0), 2)
	# Waits for tween to end and shoots the bolt
	await get_tree().create_timer(2.5).timeout
	shooting = true
	reload()
	
# Hides the harpoon for cleanup
func reload():
	var tween = create_tween()
	tween.tween_property(harpoon, "position", harpoon.position + Vector2(84, 0), 2)
	
