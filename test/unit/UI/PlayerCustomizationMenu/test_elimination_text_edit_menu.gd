extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var menu
var elimination_text_updated_times_called := 0
var elimination_text_updated_args := []

##### SETUP #####
func before_each():
	menu = load("res://Scenes/UI/PlayerCustomizationMenu/EliminationTextEditMenu/elimination_text_edit_menu.tscn").instantiate()
	elimination_text_updated_times_called = 0
	elimination_text_updated_args = []

##### TEARDOWN #####
func after_each():
	menu.free()

##### TESTS #####
func test_get_elimination_text():
	# given
	add_child_autofree(menu)
	await wait_for_signal(menu.tree_entered, 0.25)
	menu.onready_paths.text.text = "test"
	# when
	var res = menu.get_elimination_text()
	# then
	assert_eq(res, "test")

func test_set_elimination_text():
	# given
	add_child_autofree(menu)
	await wait_for_signal(menu.tree_entered, 0.25)
	# when
	menu.set_elimination_text("test")
	# then
	assert_eq(menu.onready_paths.text.text, "test")

func test_on_line_edit_text_changed():
	# given
	menu.connect("elimination_text_updated", _on_elimination_text_updated)
	# when
	menu._on_line_edit_text_changed("test")
	# then
	assert_eq(elimination_text_updated_times_called, 1)
	assert_eq(elimination_text_updated_args, [["test"]])

##### UTILS #####
func _on_elimination_text_updated(new_text: String) -> void:
	elimination_text_updated_times_called += 1
	elimination_text_updated_args.append([new_text])
