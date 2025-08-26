extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var debug_interface

##### SETUP #####
func before_each():
	debug_interface = load("res://Utils/Debug/debug_interface.gd").new()

##### TEARDOWN #####
func after_each():
	debug_interface.free()

##### TESTS #####
var process_params := [
	[true, true],
	[false, true],
	[true, false],
	[false, false]
]
func test_process(params = use_parameters(process_params)):
	# given
	var toggle_interface_pressed = params[0]
	var active = params[1]
	debug_interface._active = active
	debug_interface.visible = active
	debug_interface._properties = {
		"test_1": "first test",
		"test_2": "second test"
	}
	var label = Label.new()
	debug_interface.onready_paths.label = label
	var input = double(load("res://test/unit/Utils/test_debug_interface_mocks/input.gd")).new()
	stub(input, "is_action_just_pressed").to_return(toggle_interface_pressed)
	debug_interface._input = input
	# when
	debug_interface._process(1.0/60.0)
	# then
	assert_called(input, "is_action_just_pressed", ["toggle_debug_interface"])
	assert_eq(debug_interface._active, not active if toggle_interface_pressed else active)
	assert_eq(debug_interface.visible, debug_interface._active)
	if debug_interface._active:
		assert_eq(label.text, "test_1: first test\ntest_2: second test\n")
	assert_eq(debug_interface._properties, {})
	# cleanup
	label.free()

func test_set_debug_test():
	# given
	# when
	debug_interface.set_debug_text("test_1", "test 1")
	debug_interface.set_debug_text("test_2", "test 2")
	# then
	assert_eq(debug_interface._properties, {"test_1":"test 1", "test_2":"test 2"})

func test_stringify_properties():
	# given
	debug_interface._properties = {"test_1":"test 1", "test_2":"test 2"}
	# when
	var res = debug_interface._stringify_properties()
	# then
	assert_eq(res, "test_1: test 1\ntest_2: test 2\n")
