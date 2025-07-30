@tool
extends Node2D
# Followed GDQuest "Make an IMPRESSIVE 2D LASER Beam in Godot" video on YoutTube

@export var isCasting := false: set = set_casting
@export var color = Color.WHITE: set = set_color
@export var growthTime := 0.1
@onready var line2d: Line2D = $Line2D
@onready var laser: RayCast2D = $RayCast2D
@onready var lineWidth := line2d.width

var tween : Tween = null
var rayMaxLength = 500
var raySpeed = 100

func _ready():
	laser.collide_with_areas = true
	set_casting(true)

func _physics_process(delta: float):
	# Moves the ray forward while active
	laser.target_position.x = move_toward(
		laser.target_position.x,
		rayMaxLength,
		raySpeed * delta
	)
	# Moves the line2d that represents the laser
	var laser_end_position := laser.target_position
	laser.force_raycast_update() # Update the ray's collision query.
	
	# Checks for collision only with player
	var dontDie = 0
	while (laser.is_colliding()):
		var obj = laser.get_collider()
		if (obj.is_in_group("Bad")):
			laser.add_exception( obj )
		else:
			laser_end_position = to_local(laser.get_collision_point())
			laser.clear_exceptions()
			break
		laser.force_raycast_update()
	line2d.points[1] = laser_end_position # Sets laser current end point

func set_casting(new_value) -> void:
	if (isCasting == new_value):
		return
	isCasting = new_value
	# Disables physics while not casting
	set_physics_process(isCasting)
	if(not line2d): return
	if (isCasting == false):
		laser.target_position = Vector2.ZERO
		disappear()
	else:
		appear()

# Called when the laser is cast
func appear() -> void:
	line2d.visible = true
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(line2d, "width", lineWidth, growthTime * 2.0).from(0.0)
	pass

# Called when the laser is done casting
func disappear() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(line2d, "width", 0.0, growthTime).from_current()
	tween.tween_callback(line2d.hide) # Hides the line when tween has ended
	pass
	
func set_color(newColor: Color) -> void:
	color = newColor
	if (line2d == null):
		return
	line2d.modulate = newColor
