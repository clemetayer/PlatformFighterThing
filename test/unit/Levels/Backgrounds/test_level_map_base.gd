extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var level_map_base

##### SETUP #####
func before_each():
	level_map_base = load("res://Scenes/Levels/level_map_base.gd").new()

##### TEARDOWN #####
func after_each():
	level_map_base.free()

##### TESTS #####
func test_get_spawn_points():
	# given
	var mock_spawn_points = Node2D.new()
	level_map_base.spawn_points = mock_spawn_points
	add_child(mock_spawn_points)
	wait_for_signal(mock_spawn_points.tree_entered, 0.25)
	var nodes = create_nodes_from_array_of_vectors([Vector2.RIGHT, Vector2.UP, Vector2.ZERO], mock_spawn_points)
	# when
	var res = level_map_base.get_spawn_points()
	# then
	assert_eq(res, [Vector2.RIGHT, Vector2.UP, Vector2.ZERO])
	# cleanup
	for node in nodes:
		node.free()
	mock_spawn_points.free()

##### UTILS #####
func create_nodes_from_array_of_vectors(vectors : Array, mock_spawn_points : Node) -> Array:
	var nodes = []
	for vector in vectors:
		var node = Node2D.new()
		mock_spawn_points.add_child(node)
		wait_for_signal(node.tree_entered,0.25)
		node.global_position = vector
		nodes.append(node)
	return nodes
