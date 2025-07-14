extends CanvasLayer
# handles the communication between the player and the game root

##### SIGNALS #####
signal lives_updated(player_idx: int, new_value : int)
signal player_won
signal powerup_updated(player_idx : int, new_value)
signal movement_updated(player_idx : int, new_value)
signal game_message_triggered(message : String)

##### VARIABLES #####
#---- CONSTANTS -----
const BASE_LIVES_AMOUNT := 3
const PLAYER_SCENE_PATH := "res://Scenes/Player/player.tscn"
const SPAWN_POINT := Vector2(0, -200)
const RESPAWN_TIME := 1 # seconds


#---- EXPORTS -----

#---- STANDARD -----
#==== PRIVATE ====
var _players_data := {}
var _spawn_positions : Array
var _current_spawn_idx := 0

#==== ONREADY ====
@onready var root = $".."

##### PUBLIC METHODS #####
func init_players_data(p_players_data : Dictionary) -> void:
	for player_idx in p_players_data.keys():
		var player_config = PlayerConfig.new()
		player_config.deserialize(p_players_data[player_idx].config)
		_players_data[player_idx] = {}
		_players_data[player_idx].config = player_config
		_players_data[player_idx].lives = BASE_LIVES_AMOUNT

func init_spawn_positions(spawn_positions : Array) -> void:
	_spawn_positions = spawn_positions
	_current_spawn_idx = 0

func toggle_players_truce(active : bool) -> void:
	for player_idx in _players_data.keys():
		get_player_instance(player_idx).toggle_truce(active)

func reset() -> void:
	_players_data = {}
	clean_players()

func clean_players() -> void:
	for player in get_children():
		player.queue_free()

func add_players() -> void:
	clean_players()
	for player_idx in _players_data.keys():
		_spawn_player(player_idx, _get_spawn_position_and_go_next()) 

func get_player_instance(idx : int) -> Node2D:
	return get_node("player_%d" % idx)

func get_player_config(idx : int) -> PlayerConfig:
	return _players_data[idx].config

func get_players_data() -> Dictionary:
	return _players_data

##### PROTECTED METHODS #####
func _spawn_player(player_idx : int, spawn_position : Vector2) -> void:
	var player_instance = load(PLAYER_SCENE_PATH).instantiate()
	player_instance.id = player_idx
	player_instance.global_position = SPAWN_POINT
	player_instance.name = "player_%d" % player_idx
	add_child(player_instance)
	player_instance.global_position = spawn_position
	player_instance.connect("killed",_on_player_killed)
	player_instance.connect("movement_updated", _on_player_movement_updated)
	player_instance.connect("powerup_updated", _on_player_powerup_updated)
	player_instance.connect("game_message_triggered", _on_player_game_message_triggered)

func _get_spawn_position_and_go_next() -> Vector2:
	var spawn_position = _spawn_positions[_current_spawn_idx]
	_current_spawn_idx = (_current_spawn_idx + 1) % _spawn_positions.size() 
	return spawn_position

func _is_only_one_player_alive() -> bool:
	var players_alive := 0
	for player_idx in _players_data.keys():
		if _players_data[player_idx].lives > 0:
			players_alive += 1
	return players_alive <= 1

##### SIGNAL MANAGEMENT #####
func _on_player_killed(idx : int) -> void:
	_players_data[idx].lives -= 1
	emit_signal("lives_updated", idx, _players_data[idx].lives)
	if _players_data[idx].lives > 0:
		await get_tree().create_timer(RESPAWN_TIME).timeout
		_spawn_player(idx, _get_spawn_position_and_go_next())
	if _is_only_one_player_alive():
		emit_signal("player_won")

func _on_player_movement_updated(player_id : int, value) -> void:
	emit_signal("movement_updated", player_id, value)

func _on_player_powerup_updated(player_id : int, value) -> void:
	emit_signal("powerup_updated", player_id, value)

func _on_player_game_message_triggered(id : int) -> void:
	emit_signal("game_message_triggered",_players_data[id].config.ELIMINATION_TEXT)
