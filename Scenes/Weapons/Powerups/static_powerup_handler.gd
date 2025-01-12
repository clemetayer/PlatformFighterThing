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

##### PUBLIC METHODS #####
static func get_powerup_manager(powerup : handlers) -> PowerupBase:
	return load(scene_paths[powerup]).instantiate()
