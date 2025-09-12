extends Node2D

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"player": $"Player"
}

##### PUBLIC METHODS #####
func get_player_config(_id : int) -> PlayerConfig:
	return load("res://test/integration/Common/default_player_config.tres")

func get_player() -> Node2D:
	return onready_paths.player
