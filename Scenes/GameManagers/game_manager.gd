extends Node
class_name GameManager
# Manages the game (online or offline)

##### SIGNALS #####
# Node signals

##### ENUMS #####

##### VARIABLES #####
#---- CONSTANTS -----
const SPRITE_PRESETS_PATH := "res://Scenes/Player/SpriteCustomizationPresets/presets.tres"
const INPUT_PLAYER_CONFIG_PATH := "res://Scenes/Player/PlayerConfigs/input_player_config.tres"
const RECORD_PLAYER_CONFIG_PATH := "res://Scenes/Player/PlayerConfigs/record_player_config.tres"
const DEFAULT_LEVEL_PATH := "res://Scenes/Levels/Level1/level_1_map.tscn"
const DEFAULT_BACKGROUND_PATH := "res://Scenes/Levels/Backgrounds/TriangleCity/triangle_city.tscn"

#---- EXPORTS -----
@export var mode := StaticUtils.GAME_TYPES.OFFLINE
@export var level_data : LevelConfig

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _connected_players := {}

#==== ONREADY ====
@onready var onready_paths := {
	"game_config_menu": $"GameConfigMenu",
	"game": $"Game"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	FullScreenEffects.toggle_active(false)
	onready_paths.game_config_menu.show()
	level_data = _create_level_data()

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(_add_player)
	multiplayer.peer_disconnected.disconnect(_delete_player)

##### PUBLIC METHODS #####
func get_game_root() -> Node:
	return onready_paths.game

##### PROTECTED METHODS #####
func _init_server(port : int) -> void:
	Logger.info("starting as host on port %s" % [port])
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		Logger.error("Failed to start multiplayer server.")
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_delete_player)
	RuntimeUtils.is_offline_game = false

func _connect_to_server(ip: String, port : int) -> void:
	Logger.info("starting as client on %s:%s" % [ip,port])
	# Start as client.
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		Logger.error("Failed to start multiplayer client.")
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	RuntimeUtils.is_offline_game = false

func _create_player_data(config_path : String) -> PlayerConfig:
	var sprite_presets : SpriteCustomizationPresetsResource = load(SPRITE_PRESETS_PATH)
	sprite_presets.presets.shuffle() # to avoid picking the same element every time
	var player_config : PlayerConfig = load(config_path).duplicate()
	player_config.SPRITE_CUSTOMIZATION = sprite_presets.presets.pick_random()
	return player_config

func _create_level_data() -> LevelConfig:
	level_data = LevelConfig.new()
	level_data.level_path = DEFAULT_LEVEL_PATH
	level_data.background_and_music = DEFAULT_BACKGROUND_PATH
	return level_data

func _add_player(id : int) -> void:
	Logger.info("client %d connected" % id)
	_connected_players[id] = {
		"config":_create_player_data(INPUT_PLAYER_CONFIG_PATH)
	}
	onready_paths.game_config_menu.update_host_player_numbers(_connected_players.size())

func _delete_player(id : int) -> void:
	Logger.info("client %d disconnected" % id)
	_connected_players.erase(id)
	onready_paths.game_config_menu.update_host_player_numbers(_connected_players.size())

@rpc("authority", "call_local", "unreliable")
func _toggle_config_menu(active : bool) -> void:
	onready_paths.game_config_menu.visible = active

func _add_offline_default_players() -> void:
	_connected_players[1] = {
		"config" : _create_player_data(INPUT_PLAYER_CONFIG_PATH)
	}
	_connected_players[2] = {
		"config" : _create_player_data(RECORD_PLAYER_CONFIG_PATH)
	}

# FIXME : this method should be in the game itself, but for some reason, the remote call does not happen in it
@rpc("authority", "call_remote", "reliable")
func _add_background() -> void:
	onready_paths.game.add_background(level_data)

##### SIGNAL MANAGEMENT #####
func _on_game_config_menu_init_offline() -> void:
	_toggle_config_menu(false)
	_add_offline_default_players()
	_add_background()
	RuntimeUtils.is_offline_game = true
	FullScreenEffects.toggle_active(true)
	onready_paths.game.start(_connected_players, level_data)

func _on_game_config_menu_init_host(port: int) -> void:
	_init_server(port) 

func _on_game_config_menu_init_client(ip: String, port: int) -> void:
	_connect_to_server(ip, port)

func _on_game_config_menu_start_game() -> void:
	Logger.debug("starting game")
	rpc("_toggle_config_menu",false)
	rpc("_add_background")
	FullScreenEffects.rpc("toggle_active",true)
	onready_paths.game.start(_connected_players, level_data)

func _on_game_game_over() -> void:
	Logger.debug("game over")
	onready_paths.game.reset()
	rpc("_toggle_config_menu", true)
	FullScreenEffects.rpc("toggle_active",false)
	for player_idx in _connected_players:
		_delete_player(player_idx)
