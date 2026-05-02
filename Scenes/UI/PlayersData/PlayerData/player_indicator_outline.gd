extends Control

# handles the player indicator color outline in the UI

##### PUBLIC METHODS #####
func set_player_color(player_idx: int) -> void:
	modulate = RuntimeUtils.PLAYER_INDICATOR_COLORS[player_idx % 4]
