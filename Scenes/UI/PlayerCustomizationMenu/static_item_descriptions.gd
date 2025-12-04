extends RefCounted
class_name StaticItemDescriptions
# utils class, mostly for the UI, to get the items descriptions fairly easily

##### VARIABLES #####
#---- CONSTANTS -----
const PRIMARY_WEAPONS := {
	StaticPrimaryWeaponHandler.handlers.REVOLVER: {
		"name": "Revolver",
		"icon": "res://Scenes/Weapons/Primary/Revolver/Revolver.png",
		"description": "The revolver is a polyvalent weapon that shoots bullets in a straight line. A great choice if you want an all-rounder."
	}
}

const MOVEMENT_BONUS := {
	StaticMovementBonusHandler.handlers.DASH: {
		"name": "Dash",
		"icon": "res://Misc/Inkscape/dash.svg",
		"description": "Makes you dash up to three times before recharging. Usefull to reposition yourself quickly."
	}
}

const POWERUPS := {
	StaticPowerupHandler.handlers.SPLITTER: {
		"name": "Splitter",
		"icon": "Scenes/Weapons/Powerups/Splitter/splitter.png",
		"description": "When hit by a projectile, the splitter will split it and send it in various directions. It has limited uses. Usefull to cover a large area with your projectiles."
	}
}

##### PUBLIC METHODS #####
static func get_primary_weapons_descriptions() -> Array:
	return _get_descriptions_generic(PRIMARY_WEAPONS)

static func get_movement_bonus_descriptions() -> Array:
	return _get_descriptions_generic(MOVEMENT_BONUS)

static func get_powerups_descriptions() -> Array:
	return _get_descriptions_generic(POWERUPS)

##### PROTECTED METHODS #####
static func _get_descriptions_generic(data: Dictionary) -> Array:
	var items = []
	for element_id in data.keys():
		var item = ItemGridMenuElement.set_element(
			element_id,
			data[element_id].icon,
			data[element_id].name,
			data[element_id].description
		)
		items.append(item)
	return items
