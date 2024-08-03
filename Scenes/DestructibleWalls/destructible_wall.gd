# tool
extends Area2D
# class_name Class
# docstring

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant = 10 # Optionnal comment

#---- EXPORTS -----
@export var BASE_HEALTH := 5000 
@export var BOUNCE_BACK_DIRECTION := Vector2.RIGHT

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _health = BASE_HEALTH

#==== ONREADY ====
@onready var onready_paths := {
	"health_label":$"Label"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.health_label.text = "%f" % _health

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
func _on_body_entered(body):
	if body.is_in_group("player"):
		if BOUNCE_BACK_DIRECTION.x != 0:
			_health -= abs(body.velocity.x)
		elif BOUNCE_BACK_DIRECTION.y != 0:
			_health -= abs(body.velocity.y)
		if _health <= 0:
			queue_free()
		else:
			onready_paths.health_label.text = "%f" % _health
			if body.has_method("bounce_back"):
				body.bounce_back(BOUNCE_BACK_DIRECTION)
