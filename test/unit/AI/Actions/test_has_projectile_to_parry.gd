extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var action: ConditionHasCloseProjectile


##### SETUP #####
func before_each():
	action = ConditionHasCloseProjectile.new()
	add_child_autofree(action)


##### TESTS #####
func test_tick_not_common_blackboard():
	# given
	var blackboard = Blackboard.new()
	var actor = Node2D.new()
	# when
	var res = action.tick(actor, blackboard)
	# then
	assert_eq(res, ActionLeaf.FAILURE) # just checks the success, it should not crash
	# cleanup
	blackboard.free()
	actor.free()


func test_no_projectile():
	# given
	var blackboard = CommonBlackboard.new()
	var actor = Node2D.new()
	var player = Node2D.new()
	add_child_autofree(player)
	var projectiles = []
	blackboard.set_value(CommonBlackboard.PLAYER_KEY, player)
	blackboard.set_value(CommonBlackboard.PROJECTILES_KEY, projectiles)
	# when
	var res = action.tick(actor, blackboard)
	# then
	assert_eq(res, ConditionLeaf.FAILURE)
	# cleanup
	blackboard.free()
	actor.free()


var has_close_projectile_params := [
	[Vector2.ZERO, [Vector2.ONE], ConditionLeaf.SUCCESS],
	[Vector2.ZERO, [Vector2(120.0, 0.0)], ConditionLeaf.FAILURE],
	[Vector2.ZERO, [Vector2(-120.0, -19.5), Vector2(20.0, 10.0), Vector2(120.0, -120.0)], ConditionLeaf.SUCCESS],
	[Vector2.ONE, [Vector2(-120.0, 120.0), Vector2(150.0, 0.0), Vector2(0.0, 150.0)], ConditionLeaf.FAILURE],
]


func test_has_close_projectile(params = use_parameters(has_close_projectile_params)):
	# given
	var player_pos = params[0]
	var projectile_positions = params[1]
	var expected_status = params[2]
	var player = _create_node_at_position(player_pos)
	var projectiles = projectile_positions.map(_create_node_at_position)
	var actor = player
	var blackboard = CommonBlackboard.new()
	blackboard.set_value(CommonBlackboard.PLAYER_KEY, player)
	blackboard.set_value(CommonBlackboard.PROJECTILES_KEY, projectiles)
	# when
	var res = action.tick(actor, blackboard)
	# then
	assert_eq(res, expected_status)
	# cleanup
	blackboard.free()


##### UTILS #####
func _create_node_at_position(position: Vector2) -> Node2D:
	var node = Node2D.new()
	add_child_autofree(node)
	node.global_position = position
	return node
