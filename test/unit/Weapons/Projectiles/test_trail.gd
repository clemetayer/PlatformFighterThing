extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var trail

##### SETUP #####
func before_each():
	trail = load("res://Scenes/Weapons/Projectiles/trail.gd").new()

##### TEARDOWN #####
func after_each():
	if is_instance_valid(trail):
		trail.free()

##### TESTS #####
var process_params := [
	[false,0],
	[false,15],
	[true,15]
]
func test_process(params = use_parameters(process_params)):
	# given
	var freeze = params[0]
	var init_size = params[1]
	var parent = Node2D.new()
	parent.add_child(trail)
	add_child(parent)
	wait_for_signal(parent.tree_entered, 0.25)
	parent.global_position = Vector2.LEFT
	trail.global_position = Vector2.RIGHT
	trail.global_rotation = PI/4.0
	trail._freeze = freeze
	for i in range(init_size):
		trail.add_point(Vector2.ZERO)
	# when
	trail._process(1.0/60.0)
	# then
	if not freeze:
		assert_eq(trail.get_point_count(), init_size + 1 if init_size < trail.SIZE else init_size)
		assert_eq(trail.get_point_position(trail.get_point_count() - 1), Vector2.LEFT)
		assert_eq(trail.global_position, Vector2.ZERO)
		assert_eq(trail.global_rotation, 0)
	else:
		assert_eq(trail.global_position, Vector2.RIGHT)
		assert_almost_eq(trail.global_rotation, PI/4.0, 0.01)
	# cleanup
	trail.free()
	parent.free()

func test_reset():
	# given
	trail.points = []
	trail.add_point(Vector2.ONE)
	# when
	trail.reset()
	# then
	assert_eq(trail.points.size(), 0)

var on_SceneUtils_toggle_scene_freeze_params := [
	[true],
	[false]
]
func test_on_SceneUtils_toggle_scene_freeze(params = use_parameters(on_SceneUtils_toggle_scene_freeze_params)):
	# given
	var freeze = params[0]
	# when
	trail._on_SceneUtils_toggle_scene_freeze(freeze)
	# then
	assert_eq(trail._freeze, freeze)
