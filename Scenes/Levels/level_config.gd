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

static func deserialize(data : Dictionary) -> LevelConfig:
    var level_config = LevelConfig.new()
    StaticUtils.map_if_exists(data, "level_path", level_config, "level_path")
    StaticUtils.map_if_exists(data, "background_and_music", level_config, "background_and_music")
    return level_config    
