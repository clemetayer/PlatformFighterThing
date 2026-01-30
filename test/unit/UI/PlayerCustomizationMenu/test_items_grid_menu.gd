extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var menu
var close_triggered_times_called := 0
var item_selected_times_called := 0
var item_selected_args := []

##### SETUP #####
func before_each():
	menu = load("res://Scenes/UI/PlayerCustomizationMenu/ItemsGridMenu/items_grid_menu.tscn").instantiate()
	add_child_autofree(menu)
	await wait_for_signal(menu.tree_entered, 0.1)
	close_triggered_times_called = 0
	item_selected_times_called = 0
	item_selected_args = []

##### TEARDOWN #####
func after_each():
	if is_instance_valid(menu):
		menu.free()

##### TESTS #####
var ready_params := [
	[false, false],
	[false, true],
	[true, false],
	[true, true]
]
func test_ready(params = use_parameters(ready_params)):
	# given
	var can_be_closed = params[0]
	var small = params[1]
	menu.TITLE = "TITLE"
	menu.CAN_BE_CLOSED = can_be_closed
	menu.SMALL = small
	# when
	menu._ready()
	# then
	assert_eq(menu.onready_paths.close_button.visible, can_be_closed)
	assert_eq(menu.onready_paths.title.text, "TITLE")
	if small:
		assert_eq(menu.onready_paths.description.title.label_settings.font_size, menu.TITLE_FONT_SIZE_SMALL)
		assert_eq(menu.onready_paths.description.description.label_settings.font_size, menu.DESCRIPTION_FONT_SIZE_SMALL)
		assert_eq(menu.onready_paths.items.icon_scale, menu.ICON_SCALE_SMALL)
		assert_eq(menu.onready_paths.items.max_columns, menu.ITEMS_PER_LINE_SMALL)
	else:
		assert_eq(menu.onready_paths.description.title.label_settings.font_size, menu.TITLE_FONT_SIZE_BIG)
		assert_eq(menu.onready_paths.description.description.label_settings.font_size, menu.DESCRIPTION_FONT_SIZE_BIG)
		assert_eq(menu.onready_paths.items.icon_scale, menu.ICON_SCALE_BIG)
		assert_eq(menu.onready_paths.items.max_columns, menu.ITEMS_PER_LINE_BIG)

func test_set_items():
	# given
	var items = [
		ItemGridMenuElement.set_element(1, "res://icon.svg", "name 1", "description 1"),
		ItemGridMenuElement.set_element(2, "res://icon.svg", "name 2", "description 2")
	]
	# when
	menu.set_items(items)
	# then
	assert_eq(menu.onready_paths.items.item_count, 2)
	assert_not_null(menu.onready_paths.items.get_item_icon(0))
	assert_not_null(menu.onready_paths.items.get_item_icon(1))
	assert_eq(menu._items.size(), 2)
	assert_eq(menu._items, items)

# _resize_items already tested in _ready
# _set_item and _reset_items tested in set_items 

var update_description_with_item_params := [
	[false],
	[true]
]
func test_update_description_with_item(params = use_parameters(update_description_with_item_params)):
	# given
	var small = params[0]
	menu.SMALL = small
	var item = ItemGridMenuElement.set_element(1, "res://icon.svg", "name 1", "description 1")
	# when
	menu._update_description_with_item(item)
	# then
	if small:
		assert_ne(menu.onready_paths.description.title.text, "name 1")
		assert_ne(menu.onready_paths.description.description.text, "description 1")
	else:
		assert_not_null(menu.onready_paths.description.icon.texture)
		assert_eq(menu.onready_paths.description.title.text, "name 1")
		assert_eq(menu.onready_paths.description.description.text, "description 1")

func test_get_selected_item():
	# given
	var item_1 = ItemGridMenuElement.set_element(1, "res://icon.svg", "name 1", "description 1")
	var item_2 = ItemGridMenuElement.set_element(2, "res://icon.svg", "name 2", "description 2")
	var item_3 = ItemGridMenuElement.set_element(3, "res://icon.svg", "name 3", "description 3")
	var items = [
		item_1, item_2, item_3
	]
	menu.set_items(items)
	menu.onready_paths.items.select(1)
	# when
	var res = menu._get_selected_item()
	# then
	assert_eq(res, item_2)

func test_on_close_button_pressed():
	# given
	menu.connect("close_triggered", _on_close_triggered)
	# when
	menu._on_close_button_pressed()
	# then
	assert_eq(close_triggered_times_called, 1)

func test_on_item_list_item_selected():
	# given
	menu.SMALL = false
	var item = ItemGridMenuElement.set_element(1, "res://icon.svg", "name 1", "description 1")
	menu._items = [item]
	# when
	menu._on_item_list_item_selected(0)
	# then
	assert_not_null(menu.onready_paths.description.icon.texture)
	assert_eq(menu.onready_paths.description.title.text, "name 1")
	assert_eq(menu.onready_paths.description.description.text, "description 1")

func test_on_okay_button_pressed():
	# given
	var item_1 = ItemGridMenuElement.set_element(1, "res://icon.svg", "name 1", "description 1")
	var items = [
		item_1
	]
	menu.set_items(items)
	menu.onready_paths.items.select(0)
	menu.connect("item_selected", _on_item_selected)
	# when
	menu._on_okay_button_pressed()
	# then
	assert_eq(item_selected_times_called, 1)
	assert_eq(item_selected_args, [[item_1]])

##### UTILS #####
func _on_close_triggered() -> void:
	close_triggered_times_called += 1

func _on_item_selected(item: ItemGridMenuElement) -> void:
	item_selected_times_called += 1
	item_selected_args.append([item])
