extends Control

# chooses and handles the correct player selection menus to display

##### SIGNALS #####
signal players_ready(player_configs: Dictionary)

##### VARIABLES #####
#---- CONSTANTS -----
const MENU_PATH := "res://Scenes/UI/PlayerCustomizationMenu/player_selection_menu.tscn"

#---- STANDARD -----
#==== PRIVATE ====
var _menu
var _player_configs: Dictionary = { }


##### PUBLIC METHODS #####
func reset() -> void:
	for child in get_children():
		child.queue_free()


func init() -> void:
	var selection_menu = load(MENU_PATH).instantiate()
	selection_menu.connect("players_ready", _on_players_ready)
	add_child(selection_menu)
	_menu = selection_menu


##### SIGNAL MANAGEMENT #####
func _on_players_ready(player_configs: Array) -> void:
	for player_idx in range(0, player_configs.size()):
		_player_configs[player_idx] = player_configs[player_idx]
	emit_signal("players_ready", _player_configs)
