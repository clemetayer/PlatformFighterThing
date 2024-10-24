extends Node
class_name GameManager
# docstring

##### SIGNALS #####
# Node signals

##### ENUMS #####
enum MODE {OFFLINE, HOST, CLIENT}

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYER_SCENE_PATH := "res://Scenes/Player/player.tscn"
const SPAWN_POINT := Vector2(0, -200)
const RESPAWN_TIME := 1 # seconds

#---- EXPORTS -----
@export var mode : MODE = MODE.OFFLINE
@export var players_data : Array[PlayerConfig]
@export var level_data : LevelConfig

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths := {
	"level": $"Level",
	"players": $"Players"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_init_game()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(_add_player)
	multiplayer.peer_disconnected.disconnect(_delete_player)

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _init_game() -> void:
	match mode:
		MODE.OFFLINE:
			_start_local()
		MODE.HOST:
			_start_host()
		MODE.CLIENT:
			_start_client()

func _start_local() -> void:
	_add_level()
	for player_idx in range(players_data.size()):
		_add_player(player_idx)

func _start_host() -> void:
	_init_server(HOST_PORT)
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_delete_player)
	_clean_level()
	_add_level()


func _init_server(port : int) -> void:
	Logger.info("starting as host on port %s" % [port])
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		Logger.error("Failed to start multiplayer server.")
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer


func _start_client() -> void:
	_connect_to_server(SERVER_IP,HOST_PORT)

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

func _add_level() -> void:
	var level = load(level_data.level_path).instantiate()
	onready_paths.level.add_child(level)

func _clean_level() -> void:
	var level = onready_paths.level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()

func _add_player(id : int) -> void:
	_add_player_data(
		_scene_player_id_cnt, 
		load("res://Scenes/Levels/MultiplayerSandbox/default_player_config.tres"),
		id
	)
	_spawn_player(_scene_player_id_cnt)
	_scene_player_id_cnt += 1

func _spawn_player(player_idx : int) -> void:
	var player_instance = load(PLAYER_SCENE_PATH).instantiate()
	player_instance.CONFIG = players_data[player_idx]
	player_instance.scene_player_id = player_idx
	player_instance.global_position = SPAWN_POINT
	player_instance.name = "player_%d" % player_idx
	add_child(player_instance)
	player_instance.connect("killed",_on_player_killed)
	onready_paths.camera.PLAYERS[player_idx] = onready_paths.camera.get_path_to(player_instance)

func _delete_player(id: int):
	if not onready_paths.players.has_node(str(id)):
		return
	onready_paths.players.get_node(str(id)).queue_free()

##### SIGNAL MANAGEMENT #####
func _on_player_killed(player_idx : int) -> void:
	_players_data[player_idx].lives_left -= 1
	Logger.info("player %s has %s lives left" % [player_idx, _players_data[player_idx].lives_left])
	await get_tree().create_timer(RESPAWN_TIME).timeout
	_spawn_player(player_idx)
