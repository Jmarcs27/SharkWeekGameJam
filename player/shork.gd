extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screenSize # Size of the game window.
var projectileScene
var bombCount = 3
var distanceToMouth = 110
var doubleShot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	projectileScene = preload("res://player/shork_projectile.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1   
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("attack"):
		shoot()
	if Input.is_action_just_pressed("bomb"):
		use_bomb()
		
	position += velocity * delta * speed
	position = position.clamp(Vector2.ZERO, screenSize)


func shoot():
	print("BANG")
	var currentPosition = $".".get_global_position()
	if(!doubleShot):
		var newProjectile = projectileScene.instantiate()
		newProjectile.position = Vector2(currentPosition[0] + distanceToMouth, currentPosition[1])
		get_parent().add_child(newProjectile)
	else:
		var topProjectile = projectileScene.instantiate()
		var bottomProjectile = projectileScene.instantiate()
		topProjectile.position = Vector2(currentPosition[0] + distanceToMouth, currentPosition[1] - 5)
		bottomProjectile.position = Vector2(currentPosition[0] + distanceToMouth, currentPosition[1] + 5)
		get_parent().add_child(topProjectile)
		get_parent().add_child(bottomProjectile)
	
func use_bomb():
	if bombCount > 0:
		print("BOOM ERRYTHING DEAD")
		bombCount -= 1


func _on_body_entered(body: Node2D) -> void:
	print("Touched ", body.name) # Replace with function body.
	doubleShot = true;
	body.hide();
	body.set_deferred("disabled", true)
