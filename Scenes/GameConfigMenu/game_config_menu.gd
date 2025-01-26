extends Control
# game config menu, to quickly choose a game manager and configure a game

##### SIGNALS #####
signal init_host(port : int)
signal init_client(ip: String, port : int)
signal init_offline()
signal start_game()

##### ENUMS #####

##### VARIABLES #####
#---- CONSTANTS -----
const WAITING_TEXT_HOST_TEMPLATE := "[wave amp=50.0 freq=5.0 connected=1]Waiting for players, currently connected : %d [/wave] "
const GAME_MANAGER_PATH := "res://Scenes/GameManagers/game_manager.tscn"

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====

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
func update_host_player_numbers(number_of_players: int) -> void:
	onready_paths.waiting_host_label.text = WAITING_TEXT_HOST_TEMPLATE % number_of_players

##### PROTECTED METHODS #####
func _option_index_to_game_type_enum(index: int) -> StaticUtils.GAME_TYPES:
	match index:
		0:
			return StaticUtils.GAME_TYPES.OFFLINE
		1:
			return StaticUtils.GAME_TYPES.HOST
		2:
			return StaticUtils.GAME_TYPES.CLIENT
	Logger.error("No game type found for option %d" % index)
	return StaticUtils.GAME_TYPES.OFFLINE # Default case, should not go here

func _toggle_menu_visible(menu_type : StaticUtils.GAME_TYPES) -> void:
	onready_paths.host.menu.visible = menu_type == StaticUtils.GAME_TYPES.HOST
	onready_paths.client.menu.visible = menu_type == StaticUtils.GAME_TYPES.CLIENT
	onready_paths.offline.menu.visible = menu_type == StaticUtils.GAME_TYPES.OFFLINE

##### SIGNAL MANAGEMENT #####
func _on_option_button_item_selected(index: int) -> void:
	_toggle_menu_visible(_option_index_to_game_type_enum(index))
	
func _on_button_pressed() -> void:
	var type = _option_index_to_game_type_enum(onready_paths.option.selected)
	match type:
		StaticUtils.GAME_TYPES.OFFLINE:
			emit_signal("init_offline")
		StaticUtils.GAME_TYPES.HOST:
			var port_str = onready_paths.host.port.text
			if port_str.is_valid_int():
				emit_signal("init_host",int(port_str))
				onready_paths.config_menu.hide()
				onready_paths.waiting_host.show()
				update_host_player_numbers(0)
			else:
				Logger.error("Port %s is not valid !" % port_str)
		StaticUtils.GAME_TYPES.CLIENT:
			var port_str = onready_paths.client.port.text
			var ip = onready_paths.client.ip.text
			if port_str.is_valid_int() and ip.is_valid_ip_address():
				emit_signal("init_client", ip, int(port_str))
				onready_paths.config_menu.hide()
				onready_paths.waiting_client.show()
			else:
				Logger.error("Port %s or ip %s is not valid !" % [port_str, ip])

func _on_host_start_button_pressed() -> void:
	emit_signal("start_game")
