extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var background_manager

##### SETUP #####
func before_each():
	background_manager = load("res://Scenes/Game/background.gd").new()

##### TEARDOWN #####
func after_each():
	background_manager.free()

##### TESTS #####
func test_add_background():
	# given
	add_child(background_manager)
	wait_for_signal(background_manager.tree_entered, 1)
	var background_path = "res://test/unit/Game/test_background_mocks/background.tscn"
	# when
	background_manager.add_background(background_path)
	# then
	wait_seconds(0.1)
	assert_eq(background_manager.get_child_count(),1)

# can't really test reset() because queue_free does not work really well with GUT
