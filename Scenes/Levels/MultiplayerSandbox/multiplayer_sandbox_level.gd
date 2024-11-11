extends Node2D
# Multiplayer sandbox level

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
var _scene_player_id_cnt := 0

#==== ONREADY ====
@onready var onready_paths := {
	"camera": $"Camera",
	"players": $"Players"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players.
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
func add_player(id: int):
	_add_player_data(
		_scene_player_id_cnt, 
		load("res://Scenes/Levels/MultiplayerSandbox/default_player_config.tres"),
		id
	)
	_spawn_player(_scene_player_id_cnt)
	_scene_player_id_cnt += 1

func _spawn_player(player_idx : int) -> void:
	var character = preload(PLAYER_SCENE_PATH).instantiate()
	# Set player id.
	character.player = _players_data[player_idx].multi_id
	character.scene_player_id = player_idx
	character.name = str(_players_data[player_idx].multi_id)
	# Set character configs
	character.CONFIG = _players_data[player_idx].config
	var sprite_color : SpriteCustomizationResource
	if player_idx == 0 :
		sprite_color = load("res://Scenes/Player/SpriteCustomizationPresets/player_1.tres")
	else:
		sprite_color = load("res://Scenes/Player/SpriteCustomizationPresets/player_2.tres")
	character.CONFIG.SPRITE_CUSTOMIZATION = sprite_color
	character.global_position = SPAWN_POINT
	character.connect("killed",_on_player_killed)
	onready_paths.players.add_child(character, true)
	onready_paths.camera.PLAYERS.append(onready_paths.camera.get_path_to(character))

func _add_player_data(player_idx : int, config : PlayerConfig, multi_id : int) -> void:
	_players_data[player_idx] = {
		"lives_left":3,
		"camera_id":player_idx,
		"config":config,
		"multi_id": multi_id
	}

func del_player(id: int):
	if not onready_paths.players.has_node(str(id)):
		return
	onready_paths.players.get_node(str(id)).queue_free()

##### SIGNAL MANAGEMENT #####
func _on_player_killed(player_idx : int) -> void:
	_players_data[player_idx].lives_left -= 1
	Logger.info("player %s has %s lives left" % [player_idx, _players_data[player_idx].lives_left])
	await get_tree().create_timer(RESPAWN_TIME).timeout
	_spawn_player(player_idx)
