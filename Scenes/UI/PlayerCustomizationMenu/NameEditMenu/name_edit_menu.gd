extends MarginContainer
# Handles the edition of the player name

##### SIGNALS #####
signal name_selected(name: String)

##### VARIABLES #####
#---- CONSTANTS -----
const NAME_LIST_RESOURCE_FILE := "user://names.tres"

#---- STANDARD -----
#==== PRIVATE ====
var _name_list: NameListResource

#==== ONREADY ====
@onready var onready_paths := {
	"name_list": $"VBoxContainer/NameList",
	"current_name": $"VBoxContainer/HBoxContainer/LineEdit"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_load_name_list()
	_init_name_list()

##### PUBLIC METHODS #####
func update_player_name(p_name: String) -> void:
	onready_paths.current_name.text = p_name
	_filter_name_list(p_name)

##### PROTECTED METHODS #####
func _load_name_list() -> void:
	if ResourceLoader.exists(NAME_LIST_RESOURCE_FILE):
		_name_list = load(NAME_LIST_RESOURCE_FILE)
	else:
		GSLogger.info("Name list not existing - creating")
		_name_list = NameListResource.new()
		ResourceSaver.save(_name_list, NAME_LIST_RESOURCE_FILE)

func _init_name_list() -> void:
	_fill_item_list_with_names(_name_list.NAME_LIST)

func _fill_item_list_with_names(names: Array) -> void:
	onready_paths.name_list.clear()
	for p_name in names:
		onready_paths.name_list.add_item(p_name)

func _filter_name_list(filter: String) -> void:
	var filtered_list = _name_list.NAME_LIST.filter(func(p_name): return p_name.contains(filter))
	_fill_item_list_with_names(filtered_list)

##### SIGNAL MANAGEMENT #####
func _on_item_list_item_activated(index: int) -> void:
	var selected_name = onready_paths.name_list.get_item_text(index)
	onready_paths.current_name.text = selected_name
	_filter_name_list(selected_name)
	emit_signal("name_selected", selected_name)

func _on_add_pressed() -> void:
	var name_to_add = onready_paths.current_name.text
	_name_list.NAME_LIST.append(name_to_add)
	_name_list.NAME_LIST.sort()
	ResourceSaver.save(_name_list, NAME_LIST_RESOURCE_FILE)
	_init_name_list()
	_filter_name_list(name_to_add)
	emit_signal("name_selected", name_to_add)

func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text == "":
		_init_name_list()
	else:
		_filter_name_list(new_text)
