extends Node2D

@export var gameScene : PackedScene
@onready var normalButton = preload("res://assets/Button.png")
@onready var hoverButton = preload("res://assets/Button_Hover.png")
var gamePaused: bool = false
var new_scene : Node2D

func _ready():
	# Make node functin while the game is paused
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func pause_game(paused: bool):
	print("Game Paused set to: ", paused)
	get_tree().paused = paused
	gamePaused = paused
	self.visible = paused

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if (gamePaused):
			pause_game(false)
		else:
			pause_game(true)

func _on_quit_pressed():
	print("Game Quit")
	get_tree().quit()

func _on_start_pressed():
	if (gameScene == null):
		print("Error: Game scene is null")
		return
	pause_game(false)
	$Dead.hide()
	$Win.hide()
	
	# Starts the game if in the main menu
	if (new_scene == null): 
		new_scene = gameScene.instantiate()
		get_tree().root.get_child(0).add_child(new_scene)
		$Start.text = "Restart"
	# Restart the game if in the pause menu
	else:
		new_scene.queue_free()
		new_scene = gameScene.instantiate()
		get_tree().root.get_child(0).add_child(new_scene)

func _on_settings_pressed():
	# TODO: Add settings menu
	pass # Replace with function body.
	
func game_over():
	self.show()
	$Dead.show()
	print("GameOver")
	
func victory():
	self.show()
	$Win.show()
	print("Victory!")

########## Handles Button Hovering ##########
func _on_start_mouse_entered():
	$Start/Sprite2D.texture = normalButton
func _on_start_mouse_exited():
	$Start/Sprite2D.texture = hoverButton
func _on_settings_mouse_entered():
	$Settings/Sprite2D.texture = normalButton
func _on_settings_mouse_exited():
	$Settings/Sprite2D.texture = hoverButton
func _on_quit_mouse_entered():
	$Quit/Sprite2D.texture = normalButton
func _on_quit_mouse_exited():
	$Quit/Sprite2D.texture = hoverButton
#############################################
