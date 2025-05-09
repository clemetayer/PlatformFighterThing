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
func get_next_spawn_position() -> Vector2:
	var spawn_position = spawn_points.get_child(_spawn_counter).global_position
	_spawn_counter = (_spawn_counter + 1) % spawn_points.get_child_count()
	return spawn_position
