extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var action: ConditionIsPlayerClose


##### SETUP #####
func before_each():
	action = ConditionIsPlayerClose.new()
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


var is_player_close_params := [
	[Vector2.ZERO, 400.0, [Vector2.ONE], ConditionLeaf.SUCCESS],
	[Vector2.ZERO, 50.0, [Vector2(120.0, 0.0)], ConditionLeaf.FAILURE],
	[Vector2.ZERO, 120.0, [Vector2(-500.0, -19.5), Vector2(20.0, 10.0), Vector2(120.0, -120.0)], ConditionLeaf.SUCCESS],
	[Vector2.ONE, 250.5, [Vector2(-500.0, 120.0), Vector2(800.0, 0.0), Vector2(0.0, 253.0)], ConditionLeaf.FAILURE],
]


func test_is_player_close(params = use_parameters(is_player_close_params)):
	# given
	var player_pos = params[0]
	var distance_treshold = params[1]
	var opponents_positions = params[2]
	var expected_status = params[3]
	var player = _create_node_at_position(player_pos)
	var opponents = opponents_positions.map(_create_node_at_position)
	var actor = player
	var blackboard = CommonBlackboard.new()
	blackboard.set_value(CommonBlackboard.PLAYER_KEY, player)
	blackboard.set_value(CommonBlackboard.OPPONENTS_KEY, opponents)
	action.DISTANCE_TRESHOLD = distance_treshold
	# when
	var res = action.tick(actor, blackboard)
	# then
	assert_eq(res, expected_status)
	# cleanup
	blackboard.free()
	pass


##### UTILS #####
func _create_node_at_position(position: Vector2) -> Node2D:
	var node = Node2D.new()
	add_child_autofree(node)
	node.global_position = position
	return node
