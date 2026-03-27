extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var action: ActionResetMovement


##### SETUP #####
func before_each():
	action = ActionResetMovement.new()
	add_child_autofree(action)


##### TESTS #####
func test_tick_not_common_blackboard():
	# given
	var blackboard = Blackboard.new()
	var actor = Node2D.new()
	# when
	var res = action.tick(actor, blackboard)
	# then
	assert_eq(res, ActionLeaf.FAILURE)
	# cleanup
	blackboard.free()
	actor.free()


func test_tick():
	# given
	var blackboard = CommonBlackboard.new()
	var actor = Node2D.new()
	blackboard.set_value(CommonBlackboard.JUMP_KEY, true)
	blackboard.set_value(CommonBlackboard.MOVEMENT_DIRECTION_KEY, CommonBlackboard.DIRECTION.LEFT)
	# when
	var res = action.tick(actor, blackboard)
	# then
	assert_false(blackboard.get_value(CommonBlackboard.JUMP_KEY))
	assert_eq(blackboard.get_value(CommonBlackboard.MOVEMENT_DIRECTION_KEY), CommonBlackboard.DIRECTION.NONE)
	assert_eq(res, ActionLeaf.SUCCESS)
	# cleanup
	blackboard.free()
	actor.free()
