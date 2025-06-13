extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- CONSTANTS -----
# const CONST := "value"

#---- VARIABLES -----
var action_handler :ActionHandlerBase

##### SETUP #####
func before_each():
	action_handler = ActionHandlerBase.new()

##### TESTS #####
func test_get_action_state_all_inactive():
	for action_idx in range(action_handler.actions.size()):
		assert_eq(action_handler.get_action_state(action_idx), action_handler.states.INACTIVE, "action idx %d has an invalid state" % action_idx)

##### UTILS #####
func _something_useful():
	pass