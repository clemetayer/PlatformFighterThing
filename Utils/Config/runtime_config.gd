extends Node

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

#---- STANDARD -----
#==== PUBLIC ====
var visual_intensity : VISUAL_INTENSITY = VISUAL_INTENSITY.LOW
var camera_effects_intensity_preset : CameraEffectsIntensityPresets = load(CAMERA_EFFECTS_INTENSITY_PRESETS_PATH[CAMERA_EFFECTS_INTENSITY.LOW])
#==== PRIVATE ====
var _display_server := DisplayServer
var _audio_server := AudioServer
var _input := Input

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	GSLogger.set_logger_level(GSLogger.LOG_LEVEL_ALL)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if _input.is_action_just_pressed("temp_toggle_fullscreen"):
		if _display_server.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			_display_server.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			_display_server.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

##### PUBLIC METHODS #####
func toggle_bgm(active : bool) -> void:
	var bus_index = _audio_server.get_bus_index("BGM")
	_audio_server.set_bus_mute(bus_index,not active)

func set_visual_intensity(intensity : VISUAL_INTENSITY) -> void:
	visual_intensity = intensity

func set_camera_effects_intensity(intensity : CAMERA_EFFECTS_INTENSITY) -> void:
	camera_effects_intensity_preset = load(CAMERA_EFFECTS_INTENSITY_PRESETS_PATH[intensity])
