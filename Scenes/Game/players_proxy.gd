extends CanvasLayer
# handles the communication between the player and the game root

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var root = $".."

##### PUBLIC METHODS #####
func get_player_instance(idx : int) -> Node2D:
	return get_node("player_%d" % idx)

func get_player_config(idx : int) -> PlayerConfig:
	return root.get_player_config(idx)
