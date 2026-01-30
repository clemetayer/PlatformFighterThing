extends Object
class_name ItemGridMenuElement

@export var ITEM_ID: int
@export var ICON_PATH: String
@export var NAME: String
@export var DESCRIPTION: String

static func set_element(item_id: int, icon_path: String, name: String, description: String) -> ItemGridMenuElement:
	var element = ItemGridMenuElement.new()
	element.ITEM_ID = item_id
	element.ICON_PATH = icon_path
	element.NAME = name
	element.DESCRIPTION = description
	return element
