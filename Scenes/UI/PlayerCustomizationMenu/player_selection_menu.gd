extends Control
# Main script for the player selection menu

##### SIGNALS #####
signal players_ready(player_configs: Array)

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"player_selection_items": $"VBoxContainer/PlayerGrid"
}

##### PROTECTED METHODS #####
func _get_players_config() -> Array:
	var configs := []
	for player_selection_item in onready_paths.player_selection_items.get_children():
		var config = player_selection_item.get_config()
		if config != null:
			configs.append(config)
	return configs

##### SIGNAL MANAGEMENT #####
func _on_start_button_button_up() -> void:
	emit_signal("players_ready", _get_players_config())
