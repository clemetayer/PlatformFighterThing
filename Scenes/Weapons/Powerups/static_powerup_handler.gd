extends RefCounted
class_name StaticPowerupHandler
# Handles the choice for the weapons and returns the correct one

##### ENUMS #####
enum handlers {SPLITTER}

##### VARIABLES #####
#---- CONSTANTS -----
const scene_paths := {
	handlers.SPLITTER: "res://Scenes/Weapons/Powerups/Splitter/splitter_manager.tscn"
}

const icon_path := {
	handlers.SPLITTER: "res://Scenes/Weapons/Powerups/Splitter/splitter.png"
}

const ui_scene_paths := {
	handlers.SPLITTER: "res://Scenes/UI/PlayersData/PlayerData/Templates/progress_block.tscn"
}

##### PUBLIC METHODS #####
static func get_powerup_manager(powerup: handlers) -> PowerupBase:
	return load(scene_paths[powerup]).instantiate()

static func get_icon_path(powerup: handlers) -> String:
	return icon_path[powerup]

static func get_ui_scene(powerup: handlers) -> Node:
	return load(ui_scene_paths[powerup]).instantiate()