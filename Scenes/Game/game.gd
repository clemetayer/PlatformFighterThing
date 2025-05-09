extends Node
# Script that manages the game itself (slightly different from the game manager, which manages the game lobby)

##### SIGNALS #####
signal game_over

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYER_SCENE_PATH := "res://Scenes/Player/player.tscn"
const SPAWN_POINT := Vector2(0, -200)
const RESPAWN_TIME := 1 # seconds
const BASE_LIVES_AMOUNT := 3
const GAME_TIME := 120 #s

#---- EXPORTS -----
@export var players_data := {}

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

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
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.camera.enabled = false
	onready_paths.game_ui.hide()
	onready_paths.chronometer.hide()
	onready_paths.screen_message.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
func start(p_players_data : Dictionary, level_data : LevelConfig) -> void:
	for player_idx in p_players_data.keys():
		players_data[player_idx] = {}
		players_data[player_idx].config = p_players_data[player_idx].config
		players_data[player_idx].lives = BASE_LIVES_AMOUNT
	_add_level(level_data)
	_add_players(players_data)
	_init_game_ui(players_data)
	_init_chronometer()
	_init_screen_game_message()
	onready_paths.camera.enabled = true
	_init_start_game_animation()

func spawn_powerup(powerup : Node) -> void:
	powerup.name = "powerup_%d" % onready_paths.powerups.get_child_count()
	onready_paths.powerups.call_deferred("add_child",powerup, true)

func spawn_projectile(projectile : Node) -> void:
	projectile.name = "projectile_%d" % onready_paths.projectiles.get_child_count()
	onready_paths.projectiles.call_deferred("add_child",projectile, true)

func add_background(level_data : LevelConfig) -> void:
	_clean_background()
	_spawn_background(level_data)

func toggle_players_truce(active : bool) -> void:
	for player_idx in players_data.keys():
		players_data[player_idx].instance.toggle_truce(active)	

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
	player_instance.global_position = _level.get_next_spawn_position()
	player_instance.connect("killed",_on_player_killed)
	player_instance.connect("movement_updated", _on_player_movement_updated)
	player_instance.connect("powerup_updated", _on_player_powerup_updated)
	onready_paths.camera.PLAYERS_ROOT_PATH = onready_paths.camera.get_path_to(onready_paths.players)
	players_data[player_idx].instance = player_instance

func _add_level(level_data : LevelConfig) -> void:
	_clean_level()
	_spawn_level(level_data)

func _spawn_level(level_data : LevelConfig) -> void:
	var level = load(level_data.level_path).instantiate()
	_level = level
	onready_paths.level.add_child(level)

func _clean_level() -> void:
	for c in onready_paths.level.get_children():
		c.queue_free()

func _spawn_background(level_data : LevelConfig) -> void:
	var background = load(level_data.background_and_music).instantiate()
	onready_paths.background.add_child(background)

func _clean_background() -> void:
	for c in onready_paths.background.get_children():
		c.queue_free()

@rpc("authority","call_local","reliable")
func _init_game_ui(p_players_data : Dictionary) -> void:
	onready_paths.game_ui.clean()
	for player_idx in p_players_data.keys():
		onready_paths.game_ui.add_player(player_idx, p_players_data[player_idx].config, p_players_data[player_idx].lives)
		onready_paths.game_ui.update_lives(player_idx, players_data[player_idx].lives)
	onready_paths.game_ui.show()

func _init_chronometer() -> void:
	onready_paths.chronometer.connect("time_over", _on_chronometer_time_over)
	onready_paths.chronometer.start_timer(GAME_TIME)
	onready_paths.chronometer.show()

func _init_screen_game_message() -> void:
	onready_paths.screen_message.init()
	onready_paths.screen_message.show()

func _init_start_game_animation() -> void:
	onready_paths.animation_player.play("start_game")

func _is_game_over() -> bool:
	var players_alive := 0
	for player_idx in players_data.keys():
		if players_data[player_idx].lives > 0:
			players_alive += 1
	return players_alive <= 1

func _end_game() -> void:
	onready_paths.animation_player.play("end_game")
	await onready_paths.animation_player.animation_finished
	emit_signal("game_over")

##### SIGNAL MANAGEMENT #####
func _on_chronometer_time_over() -> void:
	_end_game()

func _on_player_killed(idx : int) -> void:
	players_data[idx].lives -= 1
	onready_paths.game_ui.update_lives(idx, players_data[idx].lives)
	if players_data[idx].lives > 0:
		await get_tree().create_timer(RESPAWN_TIME).timeout
		_spawn_player(idx)
	if _is_game_over():
		_end_game()

func _on_player_movement_updated(player_id : int, value) -> void:
	onready_paths.game_ui.update_movement(player_id, value)

func _on_player_powerup_updated(player_id : int, value) -> void:
	onready_paths.game_ui.update_powerup(player_id, value)
