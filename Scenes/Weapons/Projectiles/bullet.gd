extends Area2D
# A default bullet

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const SPEED := 1100.0 # px/s
const DAMAGE := 15.0
const KNOCKBACK := 20.0

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
var current_owner # the current "owner" of the bullet (i.e, the last thing that either spawned it, reflected it, etc.)

#==== PRIVATE ====
var _direction := Vector2.ZERO
var _speed := SPEED
var _damage := DAMAGE
var _knockback := KNOCKBACK
var _freeze := false

#==== ONREADY ====
# onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneUtils.connect("toggle_scene_freeze", _on_SceneUtils_toggle_scene_freeze)
	_direction = Vector2.RIGHT.rotated(rotation).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	if not _freeze:
		position += _direction * _speed * delta

##### PUBLIC METHODS #####
func parried(p_owner : Node2D) -> void:
	current_owner = p_owner
	rotation += PI
	_direction = Vector2.RIGHT.rotated(rotation).normalized()
	_speed *= 2
	_damage *= 2
	_knockback *= 2

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
func _on_area_entered(area):
	pass

func _on_body_entered(body):
	if body.is_in_group("player") and current_owner != body and body.has_method("hurt"):
		body.hurt(_damage, _knockback, _direction)
		queue_free()
	elif body.is_in_group("static_obstacle"): 
		queue_free()

func _on_SceneUtils_toggle_scene_freeze(value : bool) -> void:
	_freeze = value
