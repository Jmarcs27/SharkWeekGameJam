extends Area2D

@export var moveSpeed = 400 # How fast the player will move (pixels/sec).
@export var attackSpeed = 1.0
@export var bombCount = 3
@export var hitPoints = 3
@export var multiShotStacks = 1

var screenSize # Size of the game window.
var projectileScene
var distanceToMouth = 110
var doubleShot = false
var multiShotIter = 0;
var burstDelay = 0.05;

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
		velocity.x -= 0.7   
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("attack") && $AtkCooldown.is_stopped():
		print("Calling Shoot")
		shoot()
	if Input.is_action_just_pressed("bomb"):
		use_bomb()
		
	position += velocity * delta * moveSpeed
	position = position.clamp(Vector2.ZERO, screenSize)


func shoot():
	for i in range(multiShotStacks):
		print(i)
		$MultiAttackDelay.start(burstDelay * i)
	$AtkCooldown.start()
	
func use_bomb():
	if $BombCooldown.is_stopped() && bombCount > 0:
		print("BOOM ERRYTHING DEAD")
		bombCount -= 1
		$BombCooldown.start();


func _on_body_entered(body: Node2D) -> void:
	print("Touched ", body.name) 
	var entityName = body.name
	match entityName:
		"DoubleShot":
			doubleShot = true;
			body.hide();
			body.set_deferred("disabled", true)
		"MoveSpeedUp":
			moveSpeed *= 1.1
			body.hide();
			body.set_deferred("disabled", true)
		"AttackSpeedUp":
			$AtkCooldown.wait_time *= 0.75
			body.hide();
			body.set_deferred("disabled", true)


func _on_multi_attack_delay_timeout() -> void:
	print("BANG")
	var currentPosition = $".".get_global_position()
	var newProjectile = projectileScene.instantiate()
	newProjectile.position = Vector2(currentPosition[0] + distanceToMouth, currentPosition[1])
	get_parent().add_child(newProjectile)
