extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var action: ActionTargetRandomOpponent


##### SETUP #####
func before_each():
	action = ActionTargetRandomOpponent.new()


##### TESTS #####
func test_tick_not_common_blackboard():
	# given
	var blackboard = Blackboard.new()
	var actor = Node2D.new()
	# when
	var res = action.tick(actor, blackboard)
	# then
	assert_eq(res, ActionLeaf.FAILURE) # just checks the failure, it should not crash
	# cleanup
	blackboard.free()
	actor.free()
	action.free()


func test_target_random_opponent():
	# given
	var blackboard = CommonBlackboard.new()
	var opponent = Node2D.new()
	blackboard.set_value(CommonBlackboard.OPPONENTS_KEY, [opponent])
	add_child_autofree(action)
	# when
	action.tick(null, blackboard)
	# then
	assert_eq(blackboard.get_value(CommonBlackboard.TARGET_KEY), opponent)
	# cleanup
	blackboard.free()
	opponent.free()


func test_select_new_target_delay():
	# given
	action.SELECT_NEW_TARGET_DELAY = 0.1
	var blackboard = CommonBlackboard.new()
	var opponent_1 = Node2D.new()
	var opponent_2 = Node2D.new()
	blackboard.set_value(CommonBlackboard.OPPONENTS_KEY, [opponent_1])
	add_child_autofree(action)
	action._ready()
	# when
	action.tick(null, blackboard)
	# then
	assert_eq(blackboard.get_value(CommonBlackboard.TARGET_KEY), opponent_1)
	# when
	blackboard.set_value(CommonBlackboard.OPPONENTS_KEY, [opponent_2])
	await wait_seconds(0.2)
	action.tick(null, blackboard)
	# then
	assert_eq(blackboard.get_value(CommonBlackboard.TARGET_KEY), opponent_2)
	# cleanup
	blackboard.free()
	opponent_1.free()
	opponent_2.free()


func test_select_target_after_kill():
	# given
	var blackboard = CommonBlackboard.new()
	var opponent_1 = Node2D.new()
	var opponent_2 = Node2D.new()
	blackboard.set_value(CommonBlackboard.OPPONENTS_KEY, [opponent_1])
	add_child_autofree(action)
	action._ready()
	# when
	action.tick(null, blackboard)
	# then
	assert_eq(blackboard.get_value(CommonBlackboard.TARGET_KEY), opponent_1)
	# when
	blackboard.set_value(CommonBlackboard.OPPONENTS_KEY, [])
	opponent_1.tree_exited.emit()
	opponent_1.free()
	await wait_seconds(0.2)
	action.tick(null, blackboard)
	# then
	assert_null(blackboard.get_value(CommonBlackboard.TARGET_KEY))
	# when
	blackboard.set_value(CommonBlackboard.OPPONENTS_KEY, [opponent_2])
	await wait_seconds(0.2)
	action.tick(null, blackboard)
	# then
	assert_eq(blackboard.get_value(CommonBlackboard.TARGET_KEY), opponent_2)
	# cleanup
	blackboard.free()
	opponent_2.free()
