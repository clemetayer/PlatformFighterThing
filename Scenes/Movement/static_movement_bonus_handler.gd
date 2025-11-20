extends RefCounted
class_name StaticMovementBonusHandler
# static class to choose and return the corresponding handler

##### ENUMS #####
enum handlers {DASH}

##### VARIABLES #####
#---- CONSTANTS -----
const scene_paths := {
	handlers.DASH: "res://Scenes/Movement/MovementBonusDash/movement_bonus_dash.tscn"
}

const icon_path := {
	handlers.DASH: "res://Misc/Inkscape/dash.svg"
}

const ui_scene_paths := {
	handlers.DASH: "res://Scenes/UI/PlayersData/PlayerData/Templates/counter_block.tscn"
}

##### PUBLIC METHODS #####
static func get_handler(handler: handlers) -> MovementBonusBase:
	return load(scene_paths[handler]).instantiate()

static func get_icon_path(movement_bonus: handlers) -> String:
	return icon_path[movement_bonus]

static func get_ui_scene(movement_bonus: handlers) -> Node:
	return load(ui_scene_paths[movement_bonus]).instantiate()