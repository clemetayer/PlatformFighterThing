extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var action: ActionSetDesiredPositionAsTarget


##### SETUP #####
func before_each():
	action = ActionSetDesiredPositionAsTarget.new()
	add_child_autofree(action)


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


func test_set_desired_position_as_target():
	# given
	var blackboard = CommonBlackboard.new()
	blackboard.set_value(CommonBlackboard.TARGET_KEY, _create_node_at_position(Vector2.ONE))
	# when
	action.tick(null, blackboard)
	# then
	assert_eq(blackboard.get_value(CommonBlackboard.DESIRED_POSITION_KEY), Vector2.ONE)
	# cleanup
	blackboard.free()


##### UTILS #####
func _create_node_at_position(position: Vector2) -> Node2D:
	var node = Node2D.new()
	add_child_autofree(node)
	node.global_position = position
	return node
