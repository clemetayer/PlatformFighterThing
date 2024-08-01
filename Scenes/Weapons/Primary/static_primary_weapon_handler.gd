extends RefCounted
class_name StaticPrimaryWeaponHandler
# Handles the choice for the weapons and returns the correct one

##### ENUMS #####
enum weapons {REVOLVER}

##### VARIABLES #####
#---- CONSTANTS -----
const scene_paths := {
	weapons.REVOLVER: "res://Scenes/Weapons/Primary/Revolver/revolver.tscn"
}

##### PUBLIC METHODS #####
static func get_weapon(weapon : weapons) -> PrimaryWeaponBase:
	return load(scene_paths[weapon]).instantiate()

