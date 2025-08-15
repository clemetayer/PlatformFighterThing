extends Resource
class_name SpriteCustomizationResource
# Resource for the sprite customization

##### VARIABLES #####
#---- EXPORTS -----
@export var BODY_COLOR := Color.ALICE_BLUE
@export var OUTLINE_COLOR := Color.AQUAMARINE

##### PUBLIC METHODS #####
func serialize() -> Dictionary:
	return {
		"body_color":BODY_COLOR.to_html(),
		"outline_color":OUTLINE_COLOR.to_html()
	}

func deserialize(data : Dictionary) -> void:
	map_color_if_exists(data,"body_color",self,"BODY_COLOR")
	map_color_if_exists(data,"outline_color",self,"OUTLINE_COLOR")

static func map_color_if_exists(data : Dictionary, key, object, variable_name : String) -> void:
	if data.has(key):
		if variable_name in object:
			object.set(variable_name, Color.from_string(data[key], Color.WHITE))
		else:
			Logger.warn("object %s does not contain the variable %s, at %s" % [object, variable_name, get_stack()])
	else:
		Logger.warn("%s does not contain the key %s, at %s" % [data, key, get_stack()])
