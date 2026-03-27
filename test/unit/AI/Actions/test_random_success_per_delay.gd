extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var action: ConditionRandomSuccessPerDelay


##### SETUP #####
func before_each():
	action = load("res://Scenes/AI/Actions/RandomSuccessPerDelay/random_success_per_delay.tscn").instantiate()


##### TEARDOWN #####
func after_each():
	action.free()

##### TESTS #####
var no_random_params := [
	[0.0, ActionLeaf.FAILURE],
	[1.0, ActionLeaf.SUCCESS],
]


func test_no_random(params = use_parameters(no_random_params)):
	# given
	var success_chance = params[0]
	var expected_status = params[1]
	action.SUCCESS_CHANCE = success_chance
	# when
	add_child_autofree(action)
	var res = action.tick(null, null)
	# then
	assert_eq(res, expected_status)


func test_random_success():
	# given
	action.DELAY_TIME = 0.05
	# when
	add_child_autofree(action)
	var res = action.tick(null, null)
	# then
	assert_not_null(res) # since this is random, just do a check that it did not crash
	# when
	await wait_seconds(0.1)
	res = action.tick(null, null)
	# then
	assert_not_null(res) # same
