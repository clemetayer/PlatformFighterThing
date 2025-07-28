extends Resource
class_name LevelConfig
# config data for the level

##### VARIABLES #####
#---- EXPORTS -----
@export_file var level_path : String # path to the scene of the level
@export_file var background_and_music : String # path of the background and music of the scene

##### PUBLIC METHODS #####
func serialize() -> Dictionary:
	return {
		"level_path"= level_path,
		"background_and_music"= background_and_music
	}

func deserialize(data : Dictionary) -> void:
	StaticUtils.map_if_exists(data, "level_path", self, "level_path")
	StaticUtils.map_if_exists(data, "background_and_music", self, "background_and_music")
