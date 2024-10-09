extends Node2D
# Script to handle the players in the sandbox scene

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYER_SCENE_PATH := "res://Scenes/Player/player.tscn"
const RESPAWN_TIME := 1 # seconds
const SPAWN_POINT := Vector2(0, -200)

#---- EXPORTS -----
@export var player_configs : Array[PlayerConfig]

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _players_data := {}

#==== ONREADY ====
@onready var onready_paths := {
	"camera": $"Camera"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.camera.PLAYERS.resize(player_configs.size())
	_spawn_players()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _spawn_players() -> void:
	for player_idx in range(player_configs.size()):
		_spawn_player(player_idx)
		_add_player_data(player_idx)
		

func _spawn_player(player_idx : int) -> void:
	var player_instance = load(PLAYER_SCENE_PATH).instantiate()
	player_instance.CONFIG = player_configs[player_idx]
	player_instance.scene_player_id = player_idx
	player_instance.global_position = SPAWN_POINT
	player_instance.name = "player_%d" % player_idx
	add_child(player_instance)
	player_instance.connect("killed",_on_player_killed)
	onready_paths.camera.PLAYERS[player_idx] = onready_paths.camera.get_path_to(player_instance)

func _add_player_data(player_idx : int) -> void:
	_players_data[player_idx] = {
		"lives_left":3,
		"camera_id":player_idx,
		"config":player_configs[player_idx]
	}

##### SIGNAL MANAGEMENT #####
func _on_player_killed(player_idx : int) -> void:
	_players_data[player_idx].lives_left -= 1
	Logger.info("player %s has %s lives left" % [player_idx, _players_data[player_idx].lives_left])
	await get_tree().create_timer(RESPAWN_TIME).timeout
	_spawn_player(player_idx)
