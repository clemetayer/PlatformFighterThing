extends Camera2D
# Camera script

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const SCREEN_SHAKE_PRESETS := {
	CameraEffects.CAMERA_SHAKE_INTENSITY.LIGHT: "res://Scenes/Camera/ScreenShakePreset/light.tres",
	CameraEffects.CAMERA_SHAKE_INTENSITY.MEDIUM: "res://Scenes/Camera/ScreenShakePreset/medium.tres",
	CameraEffects.CAMERA_SHAKE_INTENSITY.HIGH: "res://Scenes/Camera/ScreenShakePreset/high.tres"
}
const ZOOM_OFFSET := Vector2i.ONE * 100
const ZOOM_BASE_MULTIPLIER := 0.75 # change this to correct the zoom or dezoom

#---- EXPORTS -----
@export var PLAYERS_ROOT_PATH : NodePath = "../Players"

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _current_shake_priority := CameraEffects.CAMERA_SHAKE_PRIORITY.NONE

#==== ONREADY ====
@onready var onready_paths := {
	"shaker": $"Shaker"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	CameraEffects.connect("start_camera_shake",_on_start_camera_shake)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	global_position = _get_average_position()
	var best_zoom = _get_best_zoom()
	if best_zoom > 0 :
		zoom = Vector2.ONE * best_zoom * ZOOM_BASE_MULTIPLIER
	DebugInterface.set_debug_text("Best zoom", _get_best_zoom())

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
func _get_average_position() -> Vector2:
	var sum = Vector2.ZERO
	if get_node_or_null(PLAYERS_ROOT_PATH) != null:
		var players = get_node(PLAYERS_ROOT_PATH).get_children()
		for player in players:
			sum += player.global_position
		return sum / players.size()
	return Vector2.ZERO # should never go here

func _get_best_zoom() -> float:
	var min_max_pos = _get_global_min_max_pos()
	DebugInterface.set_debug_text("Zoom min max pos", min_max_pos)
	var min_pos = min_max_pos.min
	var max_pos = min_max_pos.max
	var screen_size_offset = DisplayServer.screen_get_size() - ZOOM_OFFSET
	DebugInterface.set_debug_text("Screen size offset", screen_size_offset)
	var best_zoom := Vector2.ZERO
	DebugInterface.set_debug_text("Pos diff", Vector2(min_pos.x - max_pos.x, min_pos.y - max_pos.y))
	best_zoom.x = max(abs(min_pos.x - max_pos.x)/(screen_size_offset.x/2),1)
	best_zoom.y = max(abs(min_pos.y - max_pos.y)/(screen_size_offset.y/2),1)
	return 1/max(best_zoom.x, best_zoom.y)

func _get_global_min_max_pos() -> Dictionary:
	var min_pos := Vector2.INF
	var max_pos := Vector2.ZERO
	if get_node_or_null(PLAYERS_ROOT_PATH) != null: 
		var players = get_node(PLAYERS_ROOT_PATH).get_children()
		for player in players:
			if player.global_position.x < min_pos.x:
				min_pos.x = player.global_position.x
			if player.global_position.y < min_pos.y:
				min_pos.y = player.global_position.y
			if player.global_position.x > max_pos.x:
				max_pos.x = player.global_position.x
			if player.global_position.y > max_pos.y:
				max_pos.y = player.global_position.y
	return {
		"min": min_pos,
		"max": max_pos
	}

##### SIGNAL MANAGEMENT #####
func _on_start_camera_shake(duration : float, intensity : CameraEffects.CAMERA_SHAKE_INTENSITY, priority: CameraEffects.CAMERA_SHAKE_PRIORITY) -> void:
	if priority >= _current_shake_priority:
		if onready_paths.shaker.is_playing:
			onready_paths.shaker.force_stop_shake()
		onready_paths.shaker.set_duration(duration)
		onready_paths.shaker.set_shaker_preset(load(SCREEN_SHAKE_PRESETS[intensity]))
		onready_paths.shaker.play_shake()
		_current_shake_priority = priority


func _on_shaker_shake_finished() -> void:
	_current_shake_priority = CameraEffects.CAMERA_SHAKE_PRIORITY.NONE
