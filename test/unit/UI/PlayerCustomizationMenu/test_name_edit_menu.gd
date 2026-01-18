extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var menu
var name_selected_times_called := 0
var name_selected_args := []

##### SETUP #####
func before_each():
	menu = load("res://Scenes/UI/PlayerCustomizationMenu/NameEditMenu/name_edit_menu.tscn").instantiate()
	add_child_autofree(menu)
	await wait_for_signal(menu.tree_entered, 0.1)
	name_selected_times_called = 0
	name_selected_args = []

##### TESTS #####
# _ready and _load_name_list a bit tough to test since it interacts with an external file on the system

func test_update_player_name():
	# given
	var name_list = NameListResource.new()
	name_list.NAME_LIST = ["red", "blue", "green"]
	menu._name_list = name_list
	# when
	menu.update_player_name("re")
	# then
	assert_eq(menu.onready_paths.current_name.text, "re")
	assert_eq(menu.onready_paths.name_list.item_count, 2)
	assert_eq(menu.onready_paths.name_list.get_item_text(0), "red")
	assert_eq(menu.onready_paths.name_list.get_item_text(1), "green")

func test_init_name_list():
	# given
	var name_list = NameListResource.new()
	name_list.NAME_LIST = ["test 1", "test 2", "test 3"]
	menu._name_list = name_list
	# when
	menu._init_name_list()
	# then
	assert_eq(menu.onready_paths.name_list.item_count, 3)

func test_fill_item_list_with_names():
	# given
	var name_list = ["test 1", "test 2", "test 3"]
	# when
	menu._fill_item_list_with_names(name_list)
	# then
	assert_eq(menu.onready_paths.name_list.item_count, 3)
	assert_eq(menu.onready_paths.name_list.get_item_text(0), "test 1")
	assert_eq(menu.onready_paths.name_list.get_item_text(1), "test 2")
	assert_eq(menu.onready_paths.name_list.get_item_text(2), "test 3")

func test_filter_name_list():
	# given
	var name_list = NameListResource.new()
	name_list.NAME_LIST = ["red", "blue", "green"]
	menu._name_list = name_list
	# when
	menu._filter_name_list("re")
	# then
	assert_eq(menu.onready_paths.name_list.item_count, 2)
	assert_eq(menu.onready_paths.name_list.get_item_text(0), "red")
	assert_eq(menu.onready_paths.name_list.get_item_text(1), "green")

func test_on_item_list_item_activated():
	# given
	var name_list = NameListResource.new()
	name_list.NAME_LIST = ["test"]
	menu._name_list = name_list
	menu.connect("name_selected", _on_name_selected)
	menu._init_name_list()
	# when
	menu._on_item_list_item_activated(0)
	# then
	assert_eq(menu.onready_paths.current_name.text, "test")
	assert_eq(menu.onready_paths.name_list.item_count, 1)
	assert_eq(name_selected_times_called, 1)
	assert_eq(name_selected_args, [["test"]])

func test_on_add_presssed():
	# given
	var name_list = NameListResource.new()
	name_list.NAME_LIST = ["test"]
	menu._name_list = name_list
	menu.connect("name_selected", _on_name_selected)
	menu._init_name_list()
	menu.onready_paths.current_name.text = "test"
	# when
	menu._on_add_pressed()
	# then
	assert_eq(name_list.NAME_LIST, ["test"])
	assert_eq(menu.onready_paths.name_list.item_count, 1)
	assert_eq(name_selected_times_called, 1)
	assert_eq(name_selected_args, [["test"]])

func test_on_line_edit_text_changed():
	# given	
	var name_list = NameListResource.new()
	name_list.NAME_LIST = ["red", "blue", "green"]
	menu._name_list = name_list
	# when / then
	menu._on_line_edit_text_changed("re")
	assert_eq(menu.onready_paths.name_list.item_count, 2)
	assert_eq(menu.onready_paths.name_list.get_item_text(0), "red")
	assert_eq(menu.onready_paths.name_list.get_item_text(1), "green")
	menu._on_line_edit_text_changed("")
	assert_eq(menu.onready_paths.name_list.item_count, 3)
	assert_eq(menu.onready_paths.name_list.get_item_text(0), "red")
	assert_eq(menu.onready_paths.name_list.get_item_text(1), "blue")
	assert_eq(menu.onready_paths.name_list.get_item_text(2), "green")

##### UTILS #####
func _on_name_selected(p_name: String) -> void:
	name_selected_times_called += 1
	name_selected_args.append([p_name])