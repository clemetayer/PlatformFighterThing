extends Node
# Runtime utilitary functions

##### VARIABLES #####
#---- CONSTANTS -----
const GAME_ROOT_GROUP_NAME := "game_root"

#---- STANDARD -----
#==== PUBLIC ====
var is_offline_game := true 

##### PUBLIC METHODS #####
# Checks if from a multiplayer perspective, the id is our own
func is_own_id(id : int) -> bool:
	return multiplayer.get_unique_id() == id

# Checks if the current instance is the multiplayer authority
func is_authority() -> bool:
	return get_multiplayer_authority() == multiplayer.get_unique_id() or is_offline_game

# Returns the game root or null if it does not exists
func get_game_root() -> Node:
	return get_tree().get_first_node_in_group(GAME_ROOT_GROUP_NAME)

func is_player(body : Node2D) -> bool:
	return body != null && body.is_in_group("player")
