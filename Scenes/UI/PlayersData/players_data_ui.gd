extends HBoxContainer
# Manages the UI for all the players in the game

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _player_data_ui_scene := preload("res://Scenes/UI/PlayersData/PlayerData/player_data_ui.tscn")
var _players := {}

##### PUBLIC METHODS #####
func clean() -> void:
	for child in get_children():
		child.queue_free()

func add_player(player_id: int, config: PlayerConfig, lives: int) -> void:
	var player_data = _player_data_ui_scene.instantiate()
	add_child(player_data, true)
	player_data.init(config.SPRITE_CUSTOMIZATION, config.MOVEMENT_BONUS_HANDLER, config.POWERUP_HANDLER, config.PLAYER_NAME, lives)
	_players[player_id] = player_data

@rpc("authority", "call_local", "reliable")
func update_movement(player_id: int, value) -> void:
	if _players.has(player_id) and is_instance_valid(_players[player_id]):
		_players[player_id].update_movement(value)
	else:
		GSLogger.error("player %s does not exist in the UI" % player_id)

@rpc("authority", "call_local", "reliable")
func update_powerup(player_id: int, value) -> void:
	if _players.has(player_id) and is_instance_valid(_players[player_id]):
		_players[player_id].update_powerup(value)
	else:
		GSLogger.error("player %s does not exist in the UI" % player_id)

@rpc("authority", "call_local", "reliable")
func update_lives(player_id: int, value: int) -> void:
	if _players.has(player_id) and is_instance_valid(_players[player_id]):
		_players[player_id].update_lives(value)
	else:
		GSLogger.error("player %s does not exist in the UI" % player_id)
