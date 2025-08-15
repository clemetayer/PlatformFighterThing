extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- CONSTANTS -----
# const CONST := "value"

#---- VARIABLES -----
var input_synchronizer

##### SETUP #####
func before_each():
	input_synchronizer = load("res://Scenes/Player/input_synchronizer.gd").new()

##### TEARDOWN #####
func after_each():
	input_synchronizer.free()

##### TESTS #####
# kind of hard to test start_input_detection, it is somehow fairly hard to test the process mode
func test_set_action_handler():
	# given
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	var player_root = Node2D.new()
	add_child(player_root)
	wait_for_signal(player_root.tree_entered, 0.25)
	onready_paths_node.player_root = player_root
	input_synchronizer.onready_paths_node = onready_paths_node
	# when
	input_synchronizer.set_action_handler(StaticActionHandlerStrategy.handlers.BASE)
	# then
	assert_not_null(onready_paths_node.action_handler)
	assert_true(onready_paths_node.action_handler is ActionHandlerBase)
	assert_eq(onready_paths_node.action_handler.name, "ActionHandler")
	assert_eq(onready_paths_node.player_root.get_child_count(), 1)
	# cleanup
	player_root.free()
	onready_paths_node.free()
