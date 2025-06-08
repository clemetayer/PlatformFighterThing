extends Node
# Script that manages the game itself (slightly different from the game manager, which manages the game lobby)

##### SIGNALS #####
signal game_over

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYER_SCENE_PATH := "res://Scenes/Player/player.tscn"
const SPAWN_POINT := Vector2(0, -200)
const RESPAWN_TIME := 1 # seconds
const BASE_LIVES_AMOUNT := 3
const GAME_TIME := 120 #s
const PLAYER_GAME_MESSAGE_DURATION := 1 #s

#---- EXPORTS -----
@export var players_data := {}
@export var level_data : LevelConfig

#---- STANDARD -----
#==== PRIVATE ====
var _level : Node

#==== ONREADY ====
@onready var onready_paths := {
	"players": $"Players",
	"level": $"Level",
	"background": $"Background",
	"camera": $"Camera",
	"projectiles": $"Projectiles",
	"powerups": $"Powerups",
	"game_ui": $"UI/PlayersDataUi",
	"chronometer": $"UI/Chronometer",
	"screen_message": $"UI/ScreenGameMessage",
	"animation_player": $"AnimationPlayer"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.camera.enabled = false
	onready_paths.game_ui.hide()
	onready_paths.chronometer.hide()
	onready_paths.screen_message.hide()

##### PUBLIC METHODS #####
@rpc("authority", "call_local", "reliable")
func init_level_data(p_level_data : Dictionary) -> void:
	level_data = LevelConfig.new()
	level_data.deserialize(p_level_data)

@rpc("authority", "call_local", "reliable")
func init_players_data(p_players_data : Dictionary) -> void:
	for player_idx in p_players_data.keys():
		var player_config = PlayerConfig.new()
		player_config.deserialize(p_players_data[player_idx].config)
		players_data[player_idx] = {}
		players_data[player_idx].config = player_config
		players_data[player_idx].lives = BASE_LIVES_AMOUNT

func add_game_elements() -> void:
	_add_level(level_data)
	_add_players(players_data)
	_add_background(level_data)	

@rpc("authority", "call_local", "reliable")
func init_game_elements() -> void:
	FullScreenEffects.toggle_active(true)
	_init_game_ui(players_data)
	_init_chronometer()
	_init_screen_game_message()
	onready_paths.camera.enabled = true
	_init_start_game_animation()

func spawn_powerup(powerup : Node) -> void:
	powerup.name = "powerup_%d" % onready_paths.powerups.get_child_count()
	onready_paths.powerups.call_deferred("add_child",powerup, true)

func spawn_projectile(projectile : Node) -> void:
	onready_paths.projectiles.call_deferred("add_child", projectile, true)

func toggle_players_truce(active : bool) -> void:
	for player_idx in players_data.keys():
		onready_paths.players.get_player_instance(player_idx).toggle_truce(active)	

func reset() -> void:
	players_data = {}
	_clean_players()
	_clean_level()
	_clean_background()
	onready_paths.game_ui.clean()
	onready_paths.game_ui.hide()
	onready_paths.chronometer.hide()
	onready_paths.screen_message.hide()
	onready_paths.camera.enabled = false

func get_player_config(idx : int) -> PlayerConfig:
	return players_data[idx].config

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
	player_instance.id = player_idx
	player_instance.global_position = SPAWN_POINT
	player_instance.name = "player_%d" % player_idx
	onready_paths.players.add_child(player_instance)
	player_instance.global_position = _level.get_next_spawn_position()
	player_instance.connect("killed",_on_player_killed)
	player_instance.connect("movement_updated", _on_player_movement_updated)
	player_instance.connect("powerup_updated", _on_player_powerup_updated)
	player_instance.connect("game_message_triggered", _on_player_game_message_triggered)
	onready_paths.camera.PLAYERS_ROOT_PATH = onready_paths.camera.get_path_to(onready_paths.players)

func _add_background(p_level_data : LevelConfig) -> void:
	_clean_background()
	_spawn_background(p_level_data)

func _add_level(p_level_data : LevelConfig) -> void:
	_clean_level()
	_spawn_level(p_level_data)

func _spawn_level(p_level_data : LevelConfig) -> void:
	var level = load(p_level_data.level_path).instantiate()
	_level = level
	onready_paths.level.add_child(level)

func _clean_level() -> void:
	for c in onready_paths.level.get_children():
		c.queue_free()

func _spawn_background(p_level_data : LevelConfig) -> void:
	var background = load(p_level_data.background_and_music).instantiate()
	onready_paths.background.add_child(background)

func _clean_background() -> void:
	for c in onready_paths.background.get_children():
		c.queue_free()

# TODO : move this in the initialization node
func _init_game_ui(p_players_data : Dictionary) -> void:
	onready_paths.game_ui.clean()
	for player_idx in p_players_data.keys():
		onready_paths.game_ui.add_player(player_idx, p_players_data[player_idx].config, p_players_data[player_idx].lives)
		onready_paths.game_ui.rpc("update_lives", player_idx, p_players_data[player_idx].lives)
	onready_paths.game_ui.show()

# TODO : move this in the initialization node
func _init_chronometer() -> void:
	onready_paths.chronometer.connect("time_over", _on_chronometer_time_over)
	onready_paths.chronometer.start_timer(GAME_TIME)
	onready_paths.chronometer.show()

# TODO : move this in the initialization node
func _init_screen_game_message() -> void:
	onready_paths.screen_message.init()
	onready_paths.screen_message.show()

# TODO : move this in the initialization node
func _init_start_game_animation() -> void:
	onready_paths.animation_player.play("start_game")

func _is_game_over() -> bool:
	var players_alive := 0
	for player_idx in players_data.keys():
		if players_data[player_idx].lives > 0:
			players_alive += 1
	return players_alive <= 1

@rpc("authority", "call_local", "reliable")
func _end_game() -> void:
	onready_paths.animation_player.play("end_game")
	await onready_paths.animation_player.animation_finished
	emit_signal("game_over")

##### SIGNAL MANAGEMENT #####
func _on_chronometer_time_over() -> void:
	rpc("_end_game")

func _on_player_killed(idx : int) -> void:
	players_data[idx].lives -= 1
	onready_paths.game_ui.rpc("update_lives", idx, players_data[idx].lives)
	if players_data[idx].lives > 0:
		await get_tree().create_timer(RESPAWN_TIME).timeout
		_spawn_player(idx)
	if _is_game_over():
		rpc("_end_game")

func _on_player_movement_updated(player_id : int, value) -> void:
	onready_paths.game_ui.rpc("update_movement", player_id, value)

func _on_player_powerup_updated(player_id : int, value) -> void:
	onready_paths.game_ui.rpc("update_powerup", player_id, value)

func _on_player_game_message_triggered(message : String) -> void:
	onready_paths.screen_message.rpc("display_message", message, PLAYER_GAME_MESSAGE_DURATION, false)
