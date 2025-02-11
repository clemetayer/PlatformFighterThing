extends Node
# Singleton to trigger various camera effects

##### SIGNALS #####
signal start_camera_impact(duration : float, intensity : CAMERA_IMPACT_INTENSITY, priority : CAMERA_IMPACT_PRIORITY)

##### ENUMS #####
enum CAMERA_IMPACT_INTENSITY {LIGHT, MEDIUM, HIGH}
enum CAMERA_IMPACT_PRIORITY {NONE, LOW, MEDIUM, HIGH}

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====

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
func _process(_delta):
	pass
	
##### PUBLIC METHODS #####
func emit_signal_start_camera_impact(duration : float, intensity : CAMERA_IMPACT_INTENSITY, priority : CAMERA_IMPACT_PRIORITY = CAMERA_IMPACT_PRIORITY.LOW) -> void:
	emit_signal("start_camera_impact", duration, intensity, priority)

	
##### PROTECTED METHODS #####


##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
