extends MarginContainer
# Generic menu to display a grid of elements to select (with helpers)

##### SIGNALS #####
signal close_triggered
signal item_selected(item: ItemGridMenuElement)

##### VARIABLES #####
#---- CONSTANTS -----
const ICON_SCALE_SMALL := 1.0
const ICON_SCALE_BIG := 2.0
const ITEMS_PER_LINE_SMALL := 8
const ITEMS_PER_LINE_BIG := 16
const TITLE_FONT_SIZE_SMALL := 16
const TITLE_FONT_SIZE_BIG := 32
const DESCRIPTION_FONT_SIZE_SMALL := 10
const DESCRIPTION_FONT_SIZE_BIG := 16

#---- EXPORTS -----
@export var CAN_BE_CLOSED := true
@export var SMALL := true

#---- STANDARD -----
#==== PRIVATE ====
var _items: Array = []

#==== ONREADY ====
@onready var onready_paths := {
	"items": $"VBoxContainer/ScrollContainer/ItemList",
	"close_button": $"CloseButton",
	"description": {
		"icon": $"VBoxContainer/Description/Icon",
		"title": $"VBoxContainer/Description/VBoxContainer/Title",
		"description": $"VBoxContainer/Description/VBoxContainer/ScrollContainer/Description"
	}
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_resize_items()
	onready_paths.close_button.visible = CAN_BE_CLOSED


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
func _resize_items() -> void:
	onready_paths.description.title.label_settings.font_size = TITLE_FONT_SIZE_SMALL if SMALL else TITLE_FONT_SIZE_BIG
	onready_paths.description.description.label_settings.font_size = DESCRIPTION_FONT_SIZE_SMALL if SMALL else DESCRIPTION_FONT_SIZE_BIG
	onready_paths.items.icon_scale = ICON_SCALE_SMALL if SMALL else ICON_SCALE_BIG
	onready_paths.items.max_columns = ITEMS_PER_LINE_SMALL if SMALL else ITEMS_PER_LINE_BIG

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

func _get_selected_item() -> ItemGridMenuElement:
	return _items[onready_paths.items.get_selected_items().get(0)]

##### SIGNAL MANAGEMENT #####
func _on_close_button_pressed() -> void:
	emit_signal("close_triggered")

func _on_item_list_item_selected(index: int) -> void:
	_update_description_with_item(_items[index])

func _on_okay_button_pressed() -> void:
	emit_signal("item_selected", _get_selected_item())
