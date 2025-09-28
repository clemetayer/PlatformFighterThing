extends Node2D

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"ui":$"PlayersDataUi"
}

##### PUBLIC METHODS #####
func get_ui() -> Control:
	return onready_paths.ui
