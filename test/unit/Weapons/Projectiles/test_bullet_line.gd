extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var line

##### SETUP #####
func before_each():
	line = load("res://Scenes/Weapons/Projectiles/bullet_line.gd").new()

##### TEARDOWN #####
func after_each():
	if is_instance_valid(line):
		line.free()

##### TESTS #####
var process_params := [
	[0],
	[15]
]
func test_process(params = use_parameters(process_params)):
	# given
	var init_size = params[0]
	var parent = Node2D.new()
	parent.add_child(line)
	add_child(parent)
	wait_for_signal(parent.tree_entered, 0.25)
	parent.global_position = Vector2.LEFT
	line.global_position = Vector2.RIGHT
	line.global_rotation = PI/4.0
	for i in range(init_size):
		line.add_point(Vector2.ZERO)
	# when
	line._process(1.0/60.0)
	# then
	assert_eq(line.get_point_count(), init_size + 1 if init_size < line.SIZE else init_size)
	assert_eq(line.get_point_position(line.get_point_count() - 1), Vector2.LEFT)
	assert_eq(line.global_position, Vector2.ZERO)
	assert_eq(line.global_rotation, 0)
	# cleanup
	line.free()
	parent.free()
