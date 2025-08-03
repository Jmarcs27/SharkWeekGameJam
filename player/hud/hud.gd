extends Node2D

#@onready var shork = get_node("/root").get_child(0).get_node("Shork")
@onready var shork = get_tree().get_nodes_in_group("Player")[0] # Name, recursive, owned_by_parent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateText()
	updateImages()

func updateText():
	print("Shork!: ", shork)
	if (shork == null): return
	$MoveSpeedUp/MoveSpeedText.text = "Move: " + str(shork.moveSpeed)
	$AtkSpeedUp/AtkSpeedText.text = "AtkSpd: " + str(shork.attackSpeed) + "s"

func updateImages():
	if (shork == null): return
	var i = 0
	print("HitPoints: ", shork.hitPoints, " bombCount: ", shork.bombCount)
	while i < 3:
		$HealthPool.get_child(i).visible = i < shork.hitPoints
		$ChompPool.get_child(i).visible = i < shork.bombCount
		i += 1


func _on_shork_update_hud(moveSpeed: Variant, attackSpeed: Variant, hitPoints: Variant, bombCount: Variant) -> void:
	print("Updating HUD...")
	updateText()
	updateImages()
