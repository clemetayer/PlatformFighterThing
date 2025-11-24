extends MarginContainer
# Generic menu to display a grid of elements to select (with helpers)

##### SIGNALS #####
signal close_triggered
signal item_selected(item: ItemGridMenuElement)

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _items: Array = []

#==== ONREADY ====
@onready var onready_paths := {
	"items": $"VBoxContainer/ScrollContainer/ItemList",
	"description": {
		"icon": $"VBoxContainer/Description/Icon",
		"title": $"VBoxContainer/Description/VBoxContainer/Title",
		"description": $"VBoxContainer/Description/VBoxContainer/ScrollContainer/Description"
	}
}

##### PUBLIC METHODS #####
# Parameters are an array of ItemGridMenuElement
func set_items(items: Array) -> void:
	_reset_items()
	for item in items:
		if item is ItemGridMenuElement:
			_set_item(item)
		else:
			GSLogger.error("item %s not an ItemGridMenuRessource, not adding" % item)

##### PROTECTED METHODS #####
func _set_item(item: ItemGridMenuElement) -> void:
	_items.append(item)
	onready_paths.items.add_icon_item(load(item.ICON_PATH))

func _reset_items() -> void:
	_items = []
	onready_paths.items.clear()
	onready_paths.description.icon.texture = null
	onready_paths.description.title.text = ""
	onready_paths.description.description.text = ""

func _update_description_with_item(item: ItemGridMenuElement) -> void:
	onready_paths.description.icon.texture = load(item.ICON_PATH)
	onready_paths.description.title.text = item.NAME
	onready_paths.description.description.text = item.DESCRIPTION

##### SIGNAL MANAGEMENT #####
func _on_close_button_pressed() -> void:
	emit_signal("close_triggered")

func _on_item_list_item_selected(index: int) -> void:
	emit_signal("item_selected", _items[index])
	_update_description_with_item(_items[index])
