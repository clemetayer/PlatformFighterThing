extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var action: ActionAimAtTarget


##### SETUP #####
func before_each():
	action = ActionAimAtTarget.new()
	add_child_autofree(action)


#### TESTS #####
func test_tick_not_common_blackboard():
	# given
	var blackboard = Blackboard.new()
	var actor = Node2D.new()
	# when
	var res = action.tick(actor, blackboard)
	# then
	assert_eq(res, ActionLeaf.FAILURE) # mostly check that it does not crash
	# cleanup
	blackboard.free()
	actor.free()


var aim_position_gets_closer_to_target := [
	[Vector2(150.0, 0.0), Vector2(0.0, 0.0), Vector2(120.0, -25.0)],
	[Vector2(-150.0, 0.0), Vector2(0.0, -50.0), Vector2(-120.0, 0.0)],
	[Vector2(0.0, 0.0), Vector2(150.0, -50.0), Vector2(120.0, 90.0)],
	[Vector2(0.0, 0.0), Vector2(-150.0, 50.0), Vector2(-120.0, -90.0)],
]


func test_aim_position_gets_closer_to_target(params = use_parameters(aim_position_gets_closer_to_target)):
	# given
	var target_pos = params[0]
	var player_pos = params[1]
	var relative_aim_pos = params[2]
	var target = Node2D.new()
	var player = Node2D.new()
	var actor = Node2D.new()
	add_child_autofree(target)
	add_child_autofree(player)
	target.global_position = target_pos
	player.global_position = player_pos
	var blackboard = CommonBlackboard.new()
	blackboard.set_value(CommonBlackboard.PLAYER_KEY, player)
	blackboard.set_value(CommonBlackboard.TARGET_KEY, target)
	blackboard.set_value(CommonBlackboard.RELATIVE_AIM_POSITION_KEY, relative_aim_pos)
	var initial_distance = (player_pos + relative_aim_pos).distance_to(target_pos)
	action._delta = 1.0 / 60.0
	# when
	action.tick(actor, blackboard)
	# then
	relative_aim_pos = blackboard.get_value(CommonBlackboard.RELATIVE_AIM_POSITION_KEY)
	var new_distance = (player_pos + relative_aim_pos).distance_to(target_pos)
	assert_lt(new_distance, initial_distance)
	# cleanup
	actor.free()
	blackboard.free()
