# AI Preview for the player selection menu
extends MarginContainer

##### SIGNALS #####
signal close_triggered
signal show_ai_presets_triggered

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var player_display := $"VBoxContainer/PlayerConfigDisplay"


##### PUBLIC METHODS #####
func update_ai(player_config: PlayerConfig) -> void:
	player_display.update_player(player_config)


##### SIGNAL MANAGEMENT #####
func _on_delete_button_pressed() -> void:
	close_triggered.emit()


func _on_ai_preset_selection_button_pressed() -> void:
	show_ai_presets_triggered.emit()
