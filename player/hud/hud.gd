extends Node2D

#@onready var shork = get_node("/root").get_child(0).get_node("Shork")
@onready var shork = get_node("%Shork") # Name, recursive, owned_by_parent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateText()
	updateImages()

func updateText():
	$MoveSpeedUp/MoveSpeedText.text = "Move: " + str(shork.moveSpeed)
	$AtkSpeedUp/AtkSpeedText.text = "AtkSpd: " + str(shork.attackSpeed) + "s"

func updateImages():
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
