extends Node2D

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var players_data = {}
var level_data

#==== ONREADY ====
@onready var onready_paths := {
	"game": $"Game"
}

##### PUBLIC METHODS #####
func set_player_data(id : int, config : PlayerConfig) -> void:
	players_data[id] = {}
	players_data[id]["config"] = config

func init_players_data() -> void:
	var data_deserialized = {}
	for player_id in players_data.keys():
		data_deserialized[player_id] = {}
		data_deserialized[player_id]["config"] = players_data[player_id].config.serialize()
	onready_paths.game.init_players_data(data_deserialized)

func set_level_data(data : LevelConfig) -> void:
	level_data = data

func init_level_data() -> void:
	onready_paths.game.init_level_data(level_data.serialize())

func add_game_elements() -> void:
	onready_paths.game.add_game_elements()

func init_game_elements() -> void:
	onready_paths.game.init_game_elements()

func disable_player_mouse_input(id: int):
	get_player(id).onready_paths_node.action_handler._enable_mouse_input = false

func get_game_message() -> String:
	return onready_paths.game\
		.onready_paths.ui\
		.onready_paths.screen_message\
		.onready_paths.label.text

func get_player(id: int) -> Node2D:
	for player in onready_paths.game.onready_paths.players.get_children():
		if player.id == id:
			return player
	return null

func get_projectiles_count() -> int:
	return onready_paths.game.onready_paths.projectiles.get_child_count()

func get_powerups_count() -> int:
	return onready_paths.game.onready_paths.powerups.get_child_count()

