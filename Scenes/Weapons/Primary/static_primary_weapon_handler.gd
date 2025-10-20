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

##### PUBLIC METHODS #####
static func get_weapon(weapon : handlers) -> PrimaryWeaponBase:
	return load(scene_paths[weapon]).instantiate()
