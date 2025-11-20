extends RefCounted
class_name StaticPrimaryWeaponHandler
# Handles the choice for the handlers and returns the correct one

##### ENUMS #####
enum handlers {REVOLVER}

##### VARIABLES #####
#---- CONSTANTS -----
const scene_paths := {
	handlers.REVOLVER: "res://Scenes/Weapons/Primary/Revolver/revolver.tscn"
}

const icon_path := {
	handlers.REVOLVER: "res://Scenes/Weapons/Primary/Revolver/Revolver.png"
}

##### PUBLIC METHODS #####
static func get_weapon(weapon: handlers) -> PrimaryWeaponBase:
	return load(scene_paths[weapon]).instantiate()

static func get_icon_path(weapon: handlers) -> String:
	return icon_path[weapon]