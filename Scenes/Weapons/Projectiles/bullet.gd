extends Area2D
# A default bullet

##### VARIABLES #####
#---- CONSTANTS -----
const SPEED := 2200.0 # px/s
const DAMAGE := 15.0
const KNOCKBACK := 20.0

#---- EXPORTS -----
@export var speed := SPEED
@export var damage := DAMAGE
@export var knockback := KNOCKBACK
@export var freeze := false
@export var trail_color := Color.WHITE

#---- STANDARD -----
#==== PUBLIC ====
var current_owner # the current "owner" of the bullet (i.e, the last thing that either spawned it, reflected it, etc.)

#==== PRIVATE ====
var _direction := Vector2.ZERO

#==== ONREADY ====
@onready var onready_paths := {
	"trail": $"Trail"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.trail.modulate = trail_color
	SceneUtils.connect("toggle_scene_freeze", _on_SceneUtils_toggle_scene_freeze)
	_direction = Vector2.RIGHT.rotated(rotation).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	if not freeze:
		position += _direction * speed * delta

##### PUBLIC METHODS #####
func parried(p_owner : Node2D, relative_aim_position : Vector2) -> void:
	current_owner = p_owner
	rotation = Vector2.ZERO.angle_to_point(relative_aim_position)
	_direction = Vector2.RIGHT.rotated(rotation).normalized()
	speed *= 2
	damage *= 2
	knockback *= 2

##### SIGNAL MANAGEMENT #####
func _on_area_entered(area):
	pass

func _on_body_entered(body):
	if body.is_in_group("player") and current_owner != body and body.has_method("hurt"):
		body.hurt(damage, knockback, _direction, current_owner)
		queue_free()
	elif body.is_in_group("static_obstacle"): 
		queue_free()

func _on_SceneUtils_toggle_scene_freeze(value : bool) -> void:
	freeze = value
