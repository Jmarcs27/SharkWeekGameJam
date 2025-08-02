extends Area2D

@export var bossHealth: int = 50
@export var moveSpeed: int = 100

var shoot: bool = false
var secondPhase: bool = false
var harpoonScene = preload("res://enemies/scuba_boss/harpoon.tscn")

@onready var harpoonContainer = $Harpoon
@onready var scubaBoss = get_node("../scuba_boss")
@onready var mineSpwaner = get_node("../MineSpawns")
@onready var debrisSpawner = get_node("../DebrisSpawns")
@onready var mineTimer = get_node("../MineSpawnTimer")
@onready var debrisTimer = get_node("../DebrisSpawnTimer")

var min_x
var max_x
var min_y
var max_y

var dead: bool

var target_position: Vector2
var tolerance: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $AnimatedSprite2D.play()
    if $Constraints:
        var constraintBox = get_viewport_rect().size
        
        min_x = constraintBox.x / 2
        max_x = constraintBox.x * .9 

        min_y = constraintBox.y * .1
        max_y = constraintBox.y * .9 
        
        _set_target_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
    position = position.lerp(target_position, moveSpeed * delta / position.distance_to(target_position))
    if position.distance_to(target_position) < tolerance:
        _set_target_position()
    if(shoot):
        shoot_harpoon()
        shoot = false

func shoot_harpoon():
    var location = $HarpoonSpawnPoint.global_position
    var harpoon = harpoonScene.instantiate()
    harpoon.scale = Vector2(0.8, 0.8)
    harpoon.shootSpeed = 600
    harpoonContainer.add_child(harpoon)
    harpoon.prepare_shot(false)


func _on_area_entered(area: Area2D) -> void:
    if (area.is_in_group("Bullet")):
        bossHealth -= 1
        print("PP Boss hit. New boss HP: ", bossHealth)
        #TODO: Add phase change effect/animation
        if(!secondPhase && bossHealth <= 20):
            secondPhase = true
            mineTimer.wait_time = 1.5
            debrisTimer.wait_time = 1.0
            $ShotCooldown.wait_time = 3.0
            moveSpeed = 150
        if (bossHealth <= 0):
            print("Boss has entered the Dead Phase")
            scubaBoss.enable_boss()
            get_node("../MineSpawnTimer").stop()
            queue_free()
            #TODO: Add death animation
        else:
            var tween = create_tween()
            tween.tween_property(find_child("AnimatedSprite2D"), "modulate", Color(1, 0, 0, 0.9), 0.05)
            tween.tween_property(find_child("AnimatedSprite2D"), "modulate", Color(1, 1, 1, 1), 0.25)
        area.queue_free()

func _on_shot_cooldown_timeout() -> void:
    for child in harpoonContainer.get_children():
        child.queue_free()
    shoot = true
    
func _set_target_position():
    target_position = Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y))
