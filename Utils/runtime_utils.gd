extends Node

# Runtime utilitary functions

##### VARIABLES #####
#---- CONSTANTS -----
const GAME_ROOT_GROUP_NAME := "game_root"


##### PUBLIC METHODS #####
# Returns the game root or null if it does not exists
func get_game_root() -> Node:
	return get_tree().get_first_node_in_group(GAME_ROOT_GROUP_NAME)
