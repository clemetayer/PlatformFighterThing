extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var blackboard: CommonBlackboard
var tree_stub: Node


##### SETUP #####
func before_each():
	blackboard = CommonBlackboard.new()
	tree_stub = load("res://test/unit/AI/Blackboard/tree_stub.gd").new()
	blackboard.get_tree_callable = get_tree_callable


##### TEARDOWN #####
func after_each():
	tree_stub.free()


##### TESTS #####
func test_set_level_bounds_on_ready():
	# given
	var level_bounds = load("res://Scenes/LevelBounds/level_bounds.tscn").instantiate()
	var level_collision = CollisionShape2D.new()
	level_collision.shape = RectangleShape2D.new()
	level_collision.shape.size = Vector2(500.0, 250.0)
	level_bounds.add_child(level_collision)
	add_child_autofree(level_bounds)
	tree_stub.nodes_in_group[GroupUtils.LEVEL_BOUNDS_GROUP_NAME] = [level_bounds]
	# when
	add_child_autofree(blackboard)
	blackboard._ready()
	# then
	assert_eq(blackboard.get_value(CommonBlackboard.LEVEL_BOUNDS_KEY), level_bounds.get_bounds())


func test_set_opponents_and_projectiles_on_process():
	# given
	var projectiles = [Node2D.new(), Node2D.new()]
	var opponent_1 = Node2D.new()
	var opponent_2 = Node2D.new()
	var player = Node2D.new()
	var players = [opponent_1, opponent_2, player]
	tree_stub.nodes_in_group[GroupUtils.PROJECTILE_GROUP_NAME] = projectiles
	tree_stub.nodes_in_group[GroupUtils.PLAYER_GROUP_NAME] = players
	blackboard.set_value(CommonBlackboard.PLAYER_KEY, player)
	# when
	blackboard._process(1.0 / 60.0)
	# then
	assert_eq(blackboard.get_value(CommonBlackboard.PROJECTILES_KEY), projectiles)
	var opponents = blackboard.get_value(CommonBlackboard.OPPONENTS_KEY)
	assert_eq(opponents.size(), 2)
	assert_ne(opponents.find(opponent_1), -1)
	assert_ne(opponents.find(opponent_2), -1)
	# cleanup
	for projectile in projectiles:
		projectile.free()
	for p_player in players:
		p_player.free()
	blackboard.free()


##### UTILS #####
func get_tree_callable() -> Node:
	return tree_stub
