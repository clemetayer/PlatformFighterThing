extends CanvasLayer
# Manages the level within the scene

##### VARIABLES #####
#---- EXPORTS -----

#---- STANDARD -----
#==== PRIVATE ====
var _level_data : LevelConfig
var _level : Node
var _spawn_positions : Array

##### PUBLIC METHODS #####
func init_level_data(p_level_data : Dictionary) -> void:
	_level_data = LevelConfig.new()
	_level_data.deserialize(p_level_data)

func add_level() -> void:
	reset()
	_spawn_level()

func reset() -> void:
	for c in get_children():
		c.queue_free()

func get_spawn_positions() -> Array:
	return _spawn_positions	

func get_background_path() -> String:
	return _level_data.background_and_music

##### PROTECTED METHODS #####
func _spawn_level() -> void:
	var level = load(_level_data.level_path).instantiate()
	_level = level
	add_child(level)
	_spawn_positions = level.get_spawn_points()
