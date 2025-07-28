extends Area2D

@export var moveSpeed = 400 # How fast the player will move (pixels/sec).
@export var attackSpeed = 1.0
@export var bombCount = 3
@export var hitPoints = 3
@export var multiShotStacks = 1

var screenSize # Size of the game window.
var projectileScene
var distanceToMouth = 110
var burstDelay = 0.05
var multiShotIter = 0

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
		shoot(false)
	if Input.is_action_just_pressed("bomb"):
		use_bomb()
		
	position += velocity * delta * moveSpeed
	position = position.clamp(Vector2.ZERO, screenSize)

func shoot(multiShot: bool):
	var currentPosition = $".".get_global_position()
	var newProjectile = projectileScene.instantiate()
	newProjectile.position = $ProjectileSpawn.global_position
	get_parent().add_child(newProjectile)
	multiShotIter += 1
	if(multiShotIter < multiShotStacks):
		$MultiAttackDelay.start(burstDelay)
	else:
		multiShotIter = 0
	$AtkCooldown.start()


func use_bomb():
	if $BombCooldown.is_stopped() && bombCount > 0:
		print("BOOM ERRYTHING DEAD")
		bombCount -= 1
		$BombCooldown.start();


func _on_body_entered(body: Node2D) -> void:
	print("Touched ", body.name) 
	if body is PowerUp:
		grant_power_up(body)
	else:
		take_damage()


func grant_power_up(body: PowerUp):
	var entityName = body.name
	match entityName:
		"MultiShot":
			multiShotStacks += 1
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


func take_damage():
	if $DamageTimer.is_stopped():
		print("Ouch")
		hitPoints -= 1
		$DamageTimer.start()
		if hitPoints <= 0:
			print("You Deadge!")
			pass #Replace with Game Over


func _attack_delay_timeout() -> void:
	shoot(true)
