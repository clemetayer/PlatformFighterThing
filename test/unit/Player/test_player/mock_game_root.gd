extends Node2D

##### VARIABLES #####
#---- CONSTANTS -----
const DEFAULT_PLAYER_CONFIG_PATH := "res://test/unit/Player/default_player_config.tres"

#---- STANDARD -----
#==== PRIVATE ====
var _player_config = preload(DEFAULT_PLAYER_CONFIG_PATH)

##### PUBLIC METHODS #####
func get_player_config(_id : int) -> PlayerConfig:
	return _player_config
