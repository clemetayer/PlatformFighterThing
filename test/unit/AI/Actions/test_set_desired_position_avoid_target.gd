extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var action: SetDesiredPositionAvoidPlayersAndLevelBounds


##### SETUP #####
func before_each():
	action = SetDesiredPositionAvoidPlayersAndLevelBounds.new()
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


var avoid_opponents_params := [
	[[Vector2(50.0, 0.0)]],
	[[Vector2(50.0, 0.0), Vector2(-25.0, 30.0)]],
	[[Vector2(50.0, 0.0), Vector2(-25.0, 30.0), Vector2(30.0, -25.0)]],
]


func test_avoid_opponents(params = use_parameters(avoid_opponents_params)):
	# given
	var opponent_positions = params[0]
	var opponents = opponent_positions.map(_create_node_at_position)
	var level_bounds = [Vector2(-100, -100), Vector2(100, 100)]
	var init_desired_position = Vector2.ZERO
	var blackboard = CommonBlackboard.new()
	blackboard.set_value(CommonBlackboard.LEVEL_BOUNDS_KEY, level_bounds)
	blackboard.set_value(CommonBlackboard.OPPONENTS_KEY, opponents)
	blackboard.set_value(CommonBlackboard.DESIRED_POSITION_KEY, init_desired_position)
	var initial_distance = init_desired_position.distance_to(Vector2(50.0, 0.0))
	# when
	action.tick(null, blackboard)
	# then
	var new_distance = blackboard.get_value(CommonBlackboard.DESIRED_POSITION_KEY).distance_to(Vector2(50.0, 0.0))
	assert_gt(new_distance, initial_distance)
	# cleanup
	blackboard.free()


var avoid_level_bounds_params := [
	[[Vector2(0.0, 0.0), Vector2(100.0, 100.0)]],
	[[Vector2(-100.0, -50.0), Vector2(0.0, 0.0)]],
]


func test_avoid_level_bounds(params = use_parameters(avoid_level_bounds_params)):
	# given
	var bounds = params[0]
	var blackboard = CommonBlackboard.new()
	blackboard.set_value(CommonBlackboard.OPPONENTS_KEY, [_create_node_at_position(Vector2.ZERO)])
	blackboard.set_value(CommonBlackboard.LEVEL_BOUNDS_KEY, bounds)
	blackboard.set_value(CommonBlackboard.DESIRED_POSITION_KEY, Vector2.ZERO)
	# when
	action.tick(null, blackboard)
	# then
	assert_gt(blackboard.get_value(CommonBlackboard.DESIRED_POSITION_KEY).distance_to(Vector2.ZERO), 0.0)
	# cleanup
	blackboard.free()


##### UTILS #####
func _create_node_at_position(position: Vector2) -> Node2D:
	var node = Node2D.new()
	add_child_autofree(node)
	node.global_position = position
	return node
