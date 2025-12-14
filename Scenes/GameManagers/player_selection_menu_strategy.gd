extends Control
# chooses and handles the correct player selection menus to display

##### SIGNALS #####
signal players_ready(player_configs: Dictionary)

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const OFFLINE_MENU_PATH := "res://Scenes/UI/PlayerCustomizationMenu/player_selection_menu.tscn"
const HOST_MENU_PATH := "res://Scenes/UI/PlayerCustomizationMenu/host_waiting_selection_menu.tscn"
const CLIENT_MENU_PATH := "res://Scenes/UI/PlayerCustomizationMenu/online_player_selection_menu.tscn"

#---- STANDARD -----
#==== PRIVATE ====
var _menu
var _player_configs: Dictionary = {}

##### PUBLIC METHODS #####
func reset() -> void:
	for child in get_children():
		child.queue_free()

func init_offline() -> void:
	var selection_menu = load(OFFLINE_MENU_PATH).instantiate()
	selection_menu.connect("players_ready", _on_offline_players_ready)
	add_child(selection_menu)
	_menu = selection_menu

func init_host() -> void:
	var host_menu = load(HOST_MENU_PATH).instantiate()
	host_menu.connect("all_players_ready", _on_host_everyone_ready)
	add_child(host_menu)
	_menu = host_menu

func init_client() -> void:
	var client_menu = load(CLIENT_MENU_PATH).instantiate()
	client_menu.connect("player_ready", _on_online_player_ready)
	add_child(client_menu)
	_menu = client_menu

func add_player_connected() -> void:
	_menu.add_connected_player()

func remove_player_connected(id: int) -> void:
	_menu.remove_connected_player(_player_configs.has(id))

##### PROTECTED METHODS #####
@rpc("any_peer", "reliable", "call_local")
func _add_player_ready(id: int, player_data: Dictionary) -> void:
	_player_configs[id] = player_data
	if RuntimeUtils.is_authority():
		_menu.add_player_ready()

##### SIGNAL MANAGEMENT #####
func _on_offline_players_ready(player_configs: Array) -> void:
	for player_idx in range(0, player_configs.size()):
		_player_configs[player_idx] = player_configs[player_idx].serialize()
	emit_signal("players_ready", _player_configs)

func _on_online_player_ready(player_config: PlayerConfig) -> void:
	rpc("_add_player_ready", multiplayer.get_unique_id(), player_config.serialize())

func _on_host_everyone_ready() -> void:
	emit_signal("players_ready", _player_configs)