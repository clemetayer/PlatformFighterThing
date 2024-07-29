extends Camera2D
# Camera script

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const ZOOM_OFFSET := Vector2i.ONE * 100

#---- EXPORTS -----
@export var PLAYERS : Array[NodePath]

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

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
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	global_position = _get_average_position()
	zoom = Vector2.ONE * _get_best_zoom()
	DebugInterface.set_debug_text("Best zoom", _get_best_zoom())

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
func _get_average_position() -> Vector2:
	var sum = Vector2.ZERO
	for player in PLAYERS:
		sum += get_node(player).global_position
	return sum / PLAYERS.size()

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
	var min := Vector2.INF
	var max := Vector2.ZERO
	for player_path in PLAYERS:
		var player = get_node(player_path)
		if player.global_position.x < min.x:
			min.x = player.global_position.x
		if player.global_position.y < min.y:
			min.y = player.global_position.y
		if player.global_position.x > max.x:
			max.x = player.global_position.x
		if player.global_position.y > max.y:
			max.y = player.global_position.y
	return {
		"min": min,
		"max": max
	}

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received

