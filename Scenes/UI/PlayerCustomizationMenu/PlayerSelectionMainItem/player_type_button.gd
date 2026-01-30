extends Button
# Handles the player type in the customization menu

##### SIGNALS #####
signal player_type_changed(player_type: StaticActionHandler.handlers)

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYER_TYPES := [
	StaticActionHandler.handlers.INPUT,
	StaticActionHandler.handlers.RECORD
]

const PLAYER_TYPES_ICON_MAP := {
	StaticActionHandler.handlers.INPUT: {
		"icon": "res://Scenes/UI/PlayerCustomizationMenu/joystick.svg",
		"description": "handles the character with the keyboard/mouse"
	},
	StaticActionHandler.handlers.RECORD: {
		"icon": "res://Scenes/UI/PlayerCustomizationMenu/undo.svg",
		"description": "records actions with the keyboard/mouse by pressing \"*\" then replays these after pressing \"*\" again"
	}
}

#---- STANDARD -----
#==== PRIVATE ====
var _current_player_type_idx := 0

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_button_data(_current_player_type_idx)

##### PUBLIC METHODS #####
func get_selected_handler() -> StaticActionHandler.handlers:
	return PLAYER_TYPES[_current_player_type_idx]

func reset() -> void:
	_current_player_type_idx = 0
	_set_button_data(_current_player_type_idx)
	emit_signal("player_type_changed", PLAYER_TYPES[_current_player_type_idx])

##### PROTECTED METHODS #####
func _set_button_data(player_type: StaticActionHandler.handlers) -> void:
	icon = load(PLAYER_TYPES_ICON_MAP[player_type].icon)
	tooltip_text = PLAYER_TYPES_ICON_MAP[player_type].description

##### SIGNAL MANAGEMENT #####
func _on_pressed() -> void:
	_current_player_type_idx = (_current_player_type_idx + 1) % PLAYER_TYPES.size()
	_set_button_data(_current_player_type_idx)
	emit_signal("player_type_changed", PLAYER_TYPES[_current_player_type_idx])
