extends Resource
class_name SpriteCustomizationResource
# Resource for the sprite customization

##### VARIABLES #####
#---- EXPORTS -----
@export var BODY_COLOR := Color.ALICE_BLUE
@export var OUTLINE_COLOR := Color.AQUAMARINE
@export var EYES_TEXTURE_PATH: String
@export var MOUTH_TEXTURE_PATH: String

##### PUBLIC METHODS #####
func serialize() -> Dictionary:
	return {
		"body_color": BODY_COLOR.to_html(),
		"outline_color": OUTLINE_COLOR.to_html(),
		"eyes_texture_path": EYES_TEXTURE_PATH,
		"mouth_texture_path": MOUTH_TEXTURE_PATH
	}

func deserialize(data: Dictionary) -> void:
	map_color_if_exists(data, "body_color", self, "BODY_COLOR")
	map_color_if_exists(data, "outline_color", self, "OUTLINE_COLOR")
	StaticUtils.map_if_exists(data, "eyes_texture_path", self, "EYES_TEXTURE_PATH")
	StaticUtils.map_if_exists(data, "mouth_texture_path", self, "MOUTH_TEXTURE_PATH")

static func map_color_if_exists(data: Dictionary, key, object, variable_name: String) -> void:
	if data.has(key):
		if variable_name in object:
			object.set(variable_name, Color.from_string(data[key], Color.WHITE))
		else:
			GSLogger.warn("object %s does not contain the variable %s, at %s" % [object, variable_name, get_stack()])
	else:
		GSLogger.warn("%s does not contain the key %s, at %s" % [data, key, get_stack()])
