extends Control
# game config menu, to quickly choose a game manager and configure a game

##### SIGNALS #####
signal init_host(port: int)
signal init_client(ip: String, port: int)
signal init_offline()

##### VARIABLES #####
#---- CONSTANTS -----
const WAITING_TEXT_HOST_TEMPLATE := "[wave amp=50.0 freq=5.0 connected=1]Waiting for players, currently connected : %d [/wave] "
const GAME_MANAGER_PATH := "res://Scenes/GameManagers/game_manager.tscn"
const PLAYER_CUSTOMZATION_MENU_PATH := "res://Scenes/UI/PlayerCustomizationMenu/player_customization_menu.tscn"

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"option": $"GameTypeMenu/Containers/ConfigMenu/OptionButton",
	"config_menu": $"GameTypeMenu/Containers/ConfigMenu",
	"host": {
		"menu": $"GameTypeMenu/Containers/ConfigMenu/HostMenu",
		"port": $"GameTypeMenu/Containers/ConfigMenu/HostMenu/Port/LineEdit"
	},
	"client": {
		"menu": $"GameTypeMenu/Containers/ConfigMenu/ClientMenu",
		"ip": $"GameTypeMenu/Containers/ConfigMenu/ClientMenu/IP/LineEdit",
		"port": $"GameTypeMenu/Containers/ConfigMenu/ClientMenu/Port/LineEdit"
	},
	"offline": {
		"menu": $"GameTypeMenu/Containers/ConfigMenu/OfflineMenu"
	}
}

##### PUBLIC METHODS #####
func reset() -> void:
	onready_paths.config_menu.show()
	_toggle_menu_visible(StaticUtils.GAME_TYPES.OFFLINE)

##### PROTECTED METHODS #####
func _option_index_to_game_type_enum(index: int) -> StaticUtils.GAME_TYPES:
	match index:
		0:
			return StaticUtils.GAME_TYPES.OFFLINE
		1:
			return StaticUtils.GAME_TYPES.HOST
		2:
			return StaticUtils.GAME_TYPES.CLIENT
	GSLogger.error("No game type found for option %d" % index)
	return StaticUtils.GAME_TYPES.OFFLINE # Default case, should not go here

func _toggle_menu_visible(menu_type: StaticUtils.GAME_TYPES) -> void:
	onready_paths.host.menu.visible = menu_type == StaticUtils.GAME_TYPES.HOST
	onready_paths.client.menu.visible = menu_type == StaticUtils.GAME_TYPES.CLIENT

##### SIGNAL MANAGEMENT #####
func _on_option_button_item_selected(index: int) -> void:
	_toggle_menu_visible(_option_index_to_game_type_enum(index))

func _on_toggle_music_toggled(toggled_on: bool) -> void:
	RuntimeConfig.toggle_bgm(toggled_on)

func _on_visual_intensity_option_item_selected(index: int) -> void:
	match index:
		0:
			RuntimeConfig.set_visual_intensity(RuntimeConfig.VISUAL_INTENSITY.NONE)
		1:
			RuntimeConfig.set_visual_intensity(RuntimeConfig.VISUAL_INTENSITY.LOW)
		2:
			RuntimeConfig.set_visual_intensity(RuntimeConfig.VISUAL_INTENSITY.MID)
		3:
			RuntimeConfig.set_visual_intensity(RuntimeConfig.VISUAL_INTENSITY.HIGH)

func _on_camera_effects_intensity_option_item_selected(index: int) -> void:
	match index:
		0:
			RuntimeConfig.set_camera_effects_intensity(RuntimeConfig.CAMERA_EFFECTS_INTENSITY.NONE)
		1:
			RuntimeConfig.set_camera_effects_intensity(RuntimeConfig.CAMERA_EFFECTS_INTENSITY.LOW)
		2:
			RuntimeConfig.set_camera_effects_intensity(RuntimeConfig.CAMERA_EFFECTS_INTENSITY.MID)
		3:
			RuntimeConfig.set_camera_effects_intensity(RuntimeConfig.CAMERA_EFFECTS_INTENSITY.HIGH)


func _on_start_button_pressed() -> void:
	var type = _option_index_to_game_type_enum(onready_paths.option.selected)
	match type:
		StaticUtils.GAME_TYPES.OFFLINE:
			emit_signal("init_offline")
		StaticUtils.GAME_TYPES.HOST:
			var port_str = onready_paths.host.port.text
			if port_str.is_valid_int():
				emit_signal("init_host", int(port_str))
				onready_paths.config_menu.hide()
			else:
				GSLogger.error("Port %s is not valid !" % port_str)
		StaticUtils.GAME_TYPES.CLIENT:
			var port_str = onready_paths.client.port.text
			var ip = onready_paths.client.ip.text
			if port_str.is_valid_int() and ip.is_valid_ip_address():
				emit_signal("init_client", ip, int(port_str))
				onready_paths.config_menu.hide()
			else:
				GSLogger.error("Port %s or ip %s is not valid !" % [port_str, ip])

func _on_player_customization_pressed() -> void:
	get_tree().change_scene_to_file(PLAYER_CUSTOMZATION_MENU_PATH)
