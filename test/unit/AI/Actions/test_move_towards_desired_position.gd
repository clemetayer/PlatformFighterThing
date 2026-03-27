extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var action: ActionMoveTowardsDesiredPosition


##### SETUP #####
func before_each():
	action = ActionMoveTowardsDesiredPosition.new()
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


var jump_params := [
	[Vector2.ZERO, Vector2(0.0, -10.0), true],
	[Vector2(0.0, -10.0), Vector2.ZERO, false],
]


func test_jump(params = use_parameters(jump_params)):
	# given
	var player_pos = params[0]
	var desired_position = params[1]
	var expected_jump_value = params[2]
	var player = _create_node_at_position(player_pos)
	var blackboard = CommonBlackboard.new()
	blackboard.set_value(CommonBlackboard.PLAYER_KEY, player)
	blackboard.set_value(CommonBlackboard.DESIRED_POSITION_KEY, desired_position)
	# when
	action.tick(player, blackboard)
	# then
	assert_eq(blackboard.get_value(CommonBlackboard.JUMP_KEY), expected_jump_value)
	# cleanup
	blackboard.free()


var horizontal_movement_params := [
	[Vector2.ZERO, Vector2.ZERO, CommonBlackboard.DIRECTION.NONE],
	[Vector2.ZERO, Vector2.RIGHT, CommonBlackboard.DIRECTION.RIGHT],
	[Vector2.ZERO, Vector2.LEFT, CommonBlackboard.DIRECTION.LEFT],
]


func test_horizontal_movement(params = use_parameters(horizontal_movement_params)):
	# given
	var player_pos = params[0]
	var desired_position = params[1]
	var expected_direction = params[2]
	var player = _create_node_at_position(player_pos)
	var blackboard = CommonBlackboard.new()
	blackboard.set_value(CommonBlackboard.PLAYER_KEY, player)
	blackboard.set_value(CommonBlackboard.DESIRED_POSITION_KEY, desired_position)
	# when
	action.tick(player, blackboard)
	# then
	assert_eq(blackboard.get_value(CommonBlackboard.MOVEMENT_DIRECTION_KEY), expected_direction)
	# cleanup
	blackboard.free()


##### UTILS #####
func _create_node_at_position(position: Vector2) -> Node2D:
	var node = Node2D.new()
	add_child_autofree(node)
	node.global_position = position
	return node
