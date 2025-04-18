extends Node
# class_name Class
# docstring

##### SIGNALS #####
# Node signals

##### ENUMS #####
enum VISUAL_INTENSITY {NONE,LOW,MID,HIGH}
enum CAMERA_EFFECTS_INTENSITY {NONE,LOW,MID,HIGH}

##### VARIABLES #####
#---- CONSTANTS -----
const CAMERA_EFFECTS_INTENSITY_PRESETS_PATH := {
	CAMERA_EFFECTS_INTENSITY.NONE : "res://Scenes/Camera/CameraEffectsIntensityPresets/none.tres",
	CAMERA_EFFECTS_INTENSITY.LOW : "res://Scenes/Camera/CameraEffectsIntensityPresets/low.tres",
	CAMERA_EFFECTS_INTENSITY.MID : "res://Scenes/Camera/CameraEffectsIntensityPresets/mid.tres",
	CAMERA_EFFECTS_INTENSITY.HIGH : "res://Scenes/Camera/CameraEffectsIntensityPresets/high.tres"
}

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
var visual_intensity : VISUAL_INTENSITY = VISUAL_INTENSITY.LOW
var camera_effects_intensity_preset : CameraEffectsIntensityPresets = load(CAMERA_EFFECTS_INTENSITY_PRESETS_PATH[CAMERA_EFFECTS_INTENSITY.LOW])

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
	if Input.is_action_just_pressed("temp_toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

##### PUBLIC METHODS #####
func toggle_bgm(active : bool) -> void:
	var bus_index = AudioServer.get_bus_index("BGM")
	AudioServer.set_bus_mute(bus_index,not active)

func set_visual_intensity(intensity : VISUAL_INTENSITY) -> void:
	visual_intensity = intensity

func set_camera_effects_intensity(intensity : CAMERA_EFFECTS_INTENSITY) -> void:
	camera_effects_intensity_preset = load(CAMERA_EFFECTS_INTENSITY_PRESETS_PATH[intensity])

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
