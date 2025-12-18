extends Node
class_name GameManager
# Manages the game (online or offline)

##### VARIABLES #####
#---- CONSTANTS -----
const BASE_LIVES_AMOUNT := 3
const SPRITE_PRESETS_PATH := "res://Scenes/Player/SpriteCustomizationPresets/presets.tres"
const INPUT_PLAYER_CONFIG_PATH := "res://Scenes/Player/PlayerConfigs/input_player_config.tres"
const RECORD_PLAYER_CONFIG_PATH := "res://Scenes/Player/PlayerConfigs/record_player_config.tres"
const DEFAULT_LEVEL_PATH := "res://Scenes/Levels/Level1/level_1_map.tscn"
const DEFAULT_BACKGROUND_PATH := "res://Scenes/Levels/Backgrounds/TriangleCity/triangle_city.tscn"

#---- EXPORTS -----
@export var mode := StaticUtils.GAME_TYPES.OFFLINE
@export var level_data: LevelConfig

#---- STANDARD -----
#==== PRIVATE ====
var _connected_players := {}

#==== ONREADY ====
@onready var onready_paths := {
	"game_config_menu": $"GameConfigMenu",
	"player_selection_menu": $"PlayerSelectionMenuStrategy",
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
func _init_server(port: int) -> void:
	GSLogger.info("starting as host on port %s" % [port])
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		GSLogger.error("Failed to start multiplayer server.")
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_delete_player)
	RuntimeUtils.is_offline_game = false

func _connect_to_server(ip: String, port: int) -> void:
	GSLogger.info("starting as client on %s:%s" % [ip, port])
	# Start as client.
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		GSLogger.error("Failed to start multiplayer client.")
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	RuntimeUtils.is_offline_game = false

func _create_player_data(config_path: String) -> PlayerConfig:
	var sprite_presets: SpriteCustomizationPresetsResource = load(SPRITE_PRESETS_PATH)
	sprite_presets.presets.shuffle() # to avoid picking the same element every time
	var player_config: PlayerConfig = load(config_path).duplicate()
	player_config.SPRITE_CUSTOMIZATION = sprite_presets.presets.pick_random()
	return player_config

func _create_level_data() -> LevelConfig:
	level_data = LevelConfig.new()
	level_data.level_path = DEFAULT_LEVEL_PATH
	level_data.background_and_music = DEFAULT_BACKGROUND_PATH
	return level_data

func _add_player(id: int) -> void:
	GSLogger.info("client %d connected" % id)
	onready_paths.player_selection_menu.add_player_connected()

func _delete_player(id: int) -> void:
	GSLogger.info("client %d disconnected" % id)
	onready_paths.player_selection_menu.remove_connected_player(id)

func serialize_players(players: Dictionary) -> Dictionary:
	var serialized_players = {}
	for player_key in players.keys():
		serialized_players[player_key] = {
			"config": players[player_key].config.serialize()
		}
	return serialized_players


func _enrich_player_configs(player_configs: Dictionary) -> Dictionary:
	var formatted_players := {}
	for player_id in player_configs.keys():
		formatted_players[player_id] = {
			"config": player_configs[player_id],
			"lives": BASE_LIVES_AMOUNT
		}
	return formatted_players

@rpc("authority", "call_local", "reliable")
func _show_player_selection_menu() -> void:
	onready_paths.player_selection_menu.visible = true

@rpc("authority", "call_local", "reliable")
func _hide_and_reset_player_selection_menus() -> void:
	onready_paths.player_selection_menu.hide()
	onready_paths.player_selection_menu.reset()

func _init_connected_players(players: Dictionary) -> void:
	_connected_players = {}
	for player_idx in range(0, players.size()):
		_connected_players[player_idx] = {
			"config": players[player_idx]
		}

##### SIGNAL MANAGEMENT #####
func _on_game_config_menu_init_offline() -> void:
	GSLogger.debug("going to the player selection menu - offline")
	onready_paths.game_config_menu.visible = false
	onready_paths.player_selection_menu.visible = true
	onready_paths.player_selection_menu.init_offline()

func _on_game_config_menu_init_host(port: int) -> void:
	_init_server(port)
	onready_paths.game_config_menu.visible = false
	onready_paths.player_selection_menu.visible = true
	onready_paths.player_selection_menu.init_host()

func _on_game_config_menu_init_client(ip: String, port: int) -> void:
	_connect_to_server(ip, port)
	onready_paths.game_config_menu.visible = false
	onready_paths.player_selection_menu.visible = true
	onready_paths.player_selection_menu.init_client()
	
func _on_game_game_over() -> void:
	GSLogger.debug("game over")
	onready_paths.game.reset()
	onready_paths.game_config_menu.visible = true
	onready_paths.game_config_menu.reset()
	FullScreenEffects.toggle_active(false)

func _on_player_selection_menu_strategy_players_ready(player_configs: Dictionary) -> void:
	GSLogger.debug("starting game")
	_connected_players = _enrich_player_configs(player_configs)
	rpc("_hide_and_reset_player_selection_menus")
	onready_paths.game.rpc("init_level_data", level_data.serialize())
	onready_paths.game.rpc("init_players_data", _connected_players)
	onready_paths.game.add_game_elements()
	onready_paths.game.rpc("init_game_elements")
