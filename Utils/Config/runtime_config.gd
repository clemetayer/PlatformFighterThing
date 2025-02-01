extends Node
# class_name Class
# docstring

##### SIGNALS #####
# Node signals

##### ENUMS #####
enum VISUAL_INTENSITY {NONE,LOW,MID,HIGH}

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
var visual_intensity : VISUAL_INTENSITY = VISUAL_INTENSITY.MID

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
# onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	Logger.set_logger_level(Logger.LOG_LEVEL_ALL)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
func toggle_bgm(active : bool) -> void:
	var bus_index = AudioServer.get_bus_index("BGM")
	AudioServer.set_bus_mute(bus_index,not active)

func set_visual_intensity(intensity : VISUAL_INTENSITY) -> void:
	visual_intensity = intensity

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
