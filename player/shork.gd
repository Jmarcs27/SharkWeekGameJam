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
var canMoveUp = true
var canMoveDown = true
var canMoveRight = true

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	projectileScene = preload("res://player/shork_projectile.tscn")
	$Sprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	var velocity = Vector2.ZERO # The player's movement vector.
	if(!isDead):
		if Input.is_action_pressed("move_right") && canMoveRight:
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 0.7
		if Input.is_action_pressed("move_down") && canMoveDown:
			velocity.y += 1
		if Input.is_action_pressed("move_up") && canMoveUp:
			velocity.y -= 1
		if Input.is_action_pressed("attack") && $AtkCooldown.is_stopped():
			shoot()
		if Input.is_action_just_pressed("bomb"):
			use_bomb()
			
		position += velocity * delta * moveSpeed
		position = position.clamp(Vector2.ZERO, screenSize)

	else:
		velocity.y += .3
		
		position += velocity * delta * moveSpeed

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

func use_bomb():
	if $BombCooldown.is_stopped() && bombCount > 0:
		bombCount -= 1
		for child in get_parent().get_children():
			if child.is_in_group("Bad"):
				child.queue_free()
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
			$Sprite.stop()
			$Sprite.flip_v = true
		else:
			var tween = create_tween()
			tween.tween_property(find_child("Sprite"), "modulate", Color(1, 0, 0, 0.9), 0.05)
			tween.tween_property(find_child("Sprite"), "modulate", Color(1, 1, 1, 1), 1.25)



func _on_multi_attack_delay_timeout() -> void:
	shoot()


func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.name == "Ceiling":
		canMoveUp = false
	elif area.name == "Floor":
		canMoveDown = false
	elif area.name == "Wall":
		canMoveRight = false

func _on_area_exited(area: Area2D) -> void:
	if area.name == "Ceiling":
		canMoveUp = true
	elif area.name == "Floor":
		canMoveDown = true
	elif area.name == "Wall":
		canMoveRight = true
