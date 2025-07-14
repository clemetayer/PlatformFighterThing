extends Node
class_name LevelMap
# root for all the levels maps

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _spawn_counter := 0

#==== ONREADY ====
@onready var spawn_points := $"SpawnPoints"

##### PUBLIC METHODS #####
func get_spawn_points() -> Array:
	var spawn_positions = []
	for child in spawn_points.get_children():
		spawn_positions.append(child.global_position)
	return spawn_positions
