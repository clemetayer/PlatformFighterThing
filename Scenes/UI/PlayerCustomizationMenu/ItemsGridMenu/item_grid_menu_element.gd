extends Object
class_name ItemGridMenuElement

@export var ICON_PATH: String
@export var NAME: String
@export var DESCRIPTION: String

static func set_element(icon_path: String, name: String, description: String) -> ItemGridMenuElement:
	var element = ItemGridMenuElement.new()
	element.ICON_PATH = icon_path
	element.NAME = name
	element.DESCRIPTION = description
	return element
