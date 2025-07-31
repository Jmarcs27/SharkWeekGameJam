class_name Shork extends Area2D

@export var moveSpeed = 400 # How fast the player will move (pixels/sec).
@export var attackSpeed = 1.0
@export var bombCount = 3
@export var hitPoints = 3
@export var multiShotStacks = 1
@export var isDead = false

var screenSize # Size of the game window.
var projectileScene
var distanceToMouth = 110
var burstDelay = 0.05
var multiShotIter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	projectileScene = preload("res://player/shork_projectile.tscn")
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	var velocity = Vector2.ZERO # The player's movement vector.
	if(!isDead):
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 0.7
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("attack") && $AtkCooldown.is_stopped():
			shoot()
		if Input.is_action_just_pressed("bomb"):
			use_bomb()
		
		position += velocity * delta * moveSpeed
		position = position.clamp(Vector2.ZERO, screenSize)

func shoot():
	var newProjectile = projectileScene.instantiate()
	newProjectile.position = $ProjectileSpawn.global_position
	add_sibling(newProjectile)
	multiShotIter += 1
	if(multiShotIter < multiShotStacks):
		$MultiAttackDelay.start(burstDelay)
	else:
		multiShotIter = 0
	$AtkCooldown.start(attackSpeed)

# TODO
func use_bomb():
	if $BombCooldown.is_stopped() && bombCount > 0:
		print("BOOM ERRYTHING DEAD")
		bombCount -= 1
		$BombCooldown.start();


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Good"):
		grant_power_up(body)
	elif body.is_in_group("Bad"):
		take_damage()


func grant_power_up(powerUp: PowerUp):
	powerUp.apply(self)

func take_damage():
	if $DamageTimer.is_stopped():
		print("Ouch")
		hitPoints -= 1
		$DamageTimer.start()
		if hitPoints <= 0:
			print("You Deadge!")
			isDead = true
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.flip_v = true


func _on_multi_attack_delay_timeout() -> void:
	shoot()
