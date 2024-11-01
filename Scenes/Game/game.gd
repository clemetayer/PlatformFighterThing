extends Node
# Script that manages the game itself (slightly different from the game manager, which manages the game lobby)

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYER_SCENE_PATH := "res://Scenes/Player/player.tscn"
const SPAWN_POINT := Vector2(0, -200)
const RESPAWN_TIME := 1 # seconds
const BASE_LIVES_AMOUNT := 3

#---- EXPORTS -----
@export var players_data := {}

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths := {
	"players": $"Players",
	"level": $"Level",
	"camera": $"Camera"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.camera.enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
func start(p_players_data : Dictionary, level_data : LevelConfig) -> void:
	for player_idx in p_players_data.keys():
		players_data[player_idx] = {}
		players_data[player_idx].config = p_players_data[player_idx].config
		players_data[player_idx].lives = BASE_LIVES_AMOUNT
	_add_players(players_data)
	_add_level(level_data)
	onready_paths.camera.enabled = true


##### PROTECTED METHODS #####
func _add_players(p_players_data : Dictionary) -> void:
	_clean_players()
	for player_idx in p_players_data.keys():
		_spawn_player(player_idx)

func _clean_players():
	for c in onready_paths.players.get_children():
		c.queue_free()

func _spawn_player(player_idx : int) -> void:
	var player_instance = load(PLAYER_SCENE_PATH).instantiate()
	player_instance.CONFIG = players_data[player_idx].config
	player_instance.id = player_idx
	player_instance.global_position = SPAWN_POINT
	player_instance.name = "player_%d" % player_idx
	onready_paths.players.add_child(player_instance)
	player_instance.connect("killed",_on_player_killed)
	onready_paths.camera.PLAYERS_ROOT_PATH = onready_paths.camera.get_path_to(onready_paths.players)

func _add_level(level_data : LevelConfig) -> void:
	_clean_level()
	_spawn_level(level_data)

func _spawn_level(level_data : LevelConfig) -> void:
	var level = load(level_data.level_path).instantiate()
	onready_paths.level.add_child(level)

func _clean_level() -> void:
	for c in onready_paths.level.get_children():
		c.queue_free()

##### SIGNAL MANAGEMENT #####
func _on_player_killed(idx : int) -> void:
	players_data[idx].lives -= 1
	await get_tree().create_timer(RESPAWN_TIME).timeout
	_spawn_player(idx)
