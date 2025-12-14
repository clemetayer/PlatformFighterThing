extends Control
# host waiting screen for the selection menu

##### SIGNALS #####
signal all_players_ready

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYERS_CONNECTED_LABEL := "Waiting for players to be ready : %d/%d"

#---- STANDARD -----
#==== PRIVATE ====
var _connected_players := 0
var _players_ready := 0

#==== ONREADY ====
@onready var onready_paths := {
	"label": $"Label"
}

##### PUBLIC METHODS #####
func add_connected_player() -> void:
	_connected_players += 1
	_update_label()

func remove_connected_player(player_was_ready: bool) -> void:
	_connected_players -= 1
	if player_was_ready:
		_players_ready -= 1
	_update_label()
	_check_if_everyone_ready()

func add_player_ready() -> void:
	_players_ready += 1
	_update_label()
	_check_if_everyone_ready()

##### PROTECTED METHODS #####
func _update_label() -> void:
	onready_paths.label.text = PLAYERS_CONNECTED_LABEL % [_players_ready, _connected_players]

func _check_if_everyone_ready() -> void:
	if _connected_players > 0 and _connected_players == _players_ready:
		emit_signal("all_players_ready")
