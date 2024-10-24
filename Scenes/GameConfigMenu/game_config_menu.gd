extends Control
# game config menu, to quickly choose a game manager and configure a game

##### SIGNALS #####
# Node signals

##### ENUMS #####
enum GAME_TYPES {OFFLINE, HOST, CLIENT}

##### VARIABLES #####
#---- CONSTANTS -----
const WAITING_TEXT_HOST_TEMPLATE := "[wave amp=50.0 freq=5.0 connected=1]Waiting for players, currently connected : %d [/wave] "


#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _connected_players := {}

#==== ONREADY ====
@onready var onready_paths := {
	"option":$"GameTypeMenu/ConfigMenu/OptionButton",
	"config_menu": $"GameTypeMenu/ConfigMenu",
	"waiting_host": $"GameTypeMenu/WaitingHost",
	"waiting_host_label": $"GameTypeMenu/WaitingHost/RichTextLabel",
	"waiting_client": $"GameTypeMenu/WaitingClient",
	"host": {
		"menu": $"GameTypeMenu/ConfigMenu/HostMenu",
		"port": $"GameTypeMenu/ConfigMenu/HostMenu/Port/LineEdit"
	},
	"client" : {
		"menu": $"GameTypeMenu/ConfigMenu/ClientMenu",
		"ip" : $"GameTypeMenu/ConfigMenu/ClientMenu/IP/LineEdit",
		"port" : $"GameTypeMenu/ConfigMenu/ClientMenu/Port/LineEdit"
	},
	"offline" : {
		"menu" : $"GameTypeMenu/ConfigMenu/OfflineMenu"
	}
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _option_index_to_game_type_enum(index: int) -> GAME_TYPES:
	match index:
		0:
			return GAME_TYPES.OFFLINE
		1:
			return GAME_TYPES.HOST
		2:
			return GAME_TYPES.CLIENT
	Logger.error("No game type found for option %d" % index)
	return GAME_TYPES.OFFLINE # Default case, should not go here

func _toggle_menu_visible(menu_type : GAME_TYPES) -> void:
	onready_paths.host.menu.visible = menu_type == GAME_TYPES.HOST
	onready_paths.client.menu.visible = menu_type == GAME_TYPES.CLIENT
	onready_paths.offline.menu.visible = menu_type == GAME_TYPES.OFFLINE

func _init_server(port : int) -> void:
	Logger.info("starting as host on port %s" % [port])
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		Logger.error("Failed to start multiplayer server.")
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_delete_player)

func _add_player(id : int) -> void:
	Logger.info("client %d connected" % id)
	_connected_players[id] = {
		"config":load("res://Scenes/Levels/MultiplayerSandbox/default_player_config.tres")
	}
	_update_host_waiting_text()

func _delete_player(id : int) -> void:
	Logger.info("client %d disconnected" % id)
	_connected_players.erase(id)
	_update_host_waiting_text()

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

func _update_host_waiting_text() -> void:
	onready_paths.waiting_host_label.text = WAITING_TEXT_HOST_TEMPLATE % _connected_players.keys().size()

func _init_game_manager(type : GAME_TYPES) -> void:
	pass


##### SIGNAL MANAGEMENT #####
func _on_option_button_item_selected(index: int) -> void:
	_toggle_menu_visible(_option_index_to_game_type_enum(index))
	
func _on_button_pressed() -> void:
	var type = _option_index_to_game_type_enum(onready_paths.option.selected)
	match _option_index_to_game_type_enum(onready_paths.option.selected):
		GAME_TYPES.OFFLINE:
			_init_game_manager(type)
		GAME_TYPES.HOST:
			var port_str = onready_paths.host.port.text
			if port_str.is_valid_int():
				_init_server(int(port_str))
				onready_paths.config_menu.hide()
				onready_paths.waiting_host.show()
				_update_host_waiting_text()
			else:
				Logger.error("Port %s is not valid !" % port_str)
		GAME_TYPES.CLIENT:
			var port_str = onready_paths.client.port.text
			var ip = onready_paths.client.ip.text
			if port_str.is_valid_int() and ip.is_valid_ip_address():
				_connect_to_server(ip,int(port_str))
				onready_paths.config_menu.hide()
				onready_paths.waiting_client.show()
			else:
				Logger.error("Port %s or ip %s is not valid !" % [port_str, ip])
