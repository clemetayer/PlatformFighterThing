extends Control

# game config menu, to quickly choose a game manager and configure a game

##### SIGNALS #####
signal init

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYER_CUSTOMIZATION_MENU_PATH := "res://Scenes/UI/PlayerCustomizationMenu/player_customization_menu.tscn"


##### SIGNAL MANAGEMENT #####
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
	init.emit()


func _on_player_customization_pressed() -> void:
	get_tree().change_scene_to_file(PLAYER_CUSTOMIZATION_MENU_PATH)
