extends Area2D
# A default bullet

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const SPEED := 1000.0 # px/s
const DAMAGE := 10.0
const KNOCKBACK := 5.0

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
var current_owner # the current "owner" of the bullet (i.e, the last thing that either spawned it, reflected it, etc.)

#==== PRIVATE ====
var _direction := Vector2.ZERO

#==== ONREADY ====
# onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	_direction = Vector2.RIGHT.rotated(rotation).normalized()
	position += _direction * SPEED * delta

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
func _on_area_entered(area):
	# TODO
	pass

func _on_body_entered(body):
	if body.is_in_group("player") and current_owner != body and body.has_method("hurt"):
		body.hurt(DAMAGE, KNOCKBACK, _direction)
		queue_free()
	elif body.is_in_group("static_obstacle"): 
		queue_free()
