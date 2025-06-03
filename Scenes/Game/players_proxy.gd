extends CanvasLayer
# handles the communication between the player and the game root

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var root = $".."

##### PUBLIC METHODS #####
func get_player_config(idx : int) -> PlayerConfig:
	return root.get_player_config(idx)
