extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var bullet

##### SETUP #####
func before_each():
	bullet = load("res://Scenes/Weapons/Projectiles/bullet.gd").new()

##### TEARDOWN #####
func after_each():
	bullet.free()

##### TESTS #####
func test_ready():
	# given
	bullet.free()
	bullet = load("res://Scenes/Weapons/Projectiles/bullet.tscn").instantiate() # Actually loads the bullet scene to test _ready
	bullet.init_position = Vector2.RIGHT
	bullet.init_rotation = PI/4.0
	bullet.trail_color = Color.AQUA
	# when
	add_child(bullet)
	wait_for_signal(bullet.tree_entered, 0.25)
	# then
	assert_eq(bullet.global_position, Vector2.RIGHT)
	assert_almost_eq(bullet.rotation, PI/4.0, 0.001)
	assert_eq(bullet.onready_paths.trail.modulate, Color.AQUA)
	assert_eq(bullet._direction, Vector2.RIGHT.rotated(PI/4.0).normalized())

var process_params := [
	[true],
	[false]
]
func test_process(params = use_parameters(process_params)):
	# given
	var freeze = params[0]
	bullet.freeze = freeze
	bullet.position = Vector2.ZERO
	bullet._direction = Vector2.RIGHT
	bullet.speed = 2.0
	# when
	bullet._process(0.5)
	# then
	assert_eq(bullet.position, Vector2.RIGHT if not freeze else Vector2.ZERO)

func test_parried():
	# given
	var p_owner = Node2D.new()
	bullet.speed = 1.0
	bullet.damage = 2.0 
	bullet.knockback = 3.0 
	# when
	bullet.parried(p_owner, Vector2.UP)
	# then
	assert_eq(bullet.current_owner, p_owner)
	assert_almost_eq(bullet.rotation, -PI/2.0, 0.01)
	assert_eq(bullet._direction, Vector2.UP)
	assert_eq(bullet.speed, 2.0)
	assert_eq(bullet.damage, 4.0)
	assert_eq(bullet.knockback, 6.0)
	# cleanup
	p_owner.free()

var on_body_entered_params := [
	[true, true, false],
	[true, false, true],
	[true, false, false],
	[false, true, true]
]
func test_on_body_entered(params = use_parameters(on_body_entered_params)):
	# given
	var is_authority = params[0]
	var is_player = params[1]
	var is_static_obstacle = params[2]
	var body
	if is_player:
		body = double(load("res://Scenes/Player/player.gd")).new()
		stub(body, "hurt").to_do_nothing()
		body.add_to_group("player")
	elif is_static_obstacle:
		body = StaticBody2D.new()
		body.add_to_group("static_obstacle")
	else:
		body = StaticBody2D.new()
	var runtime_utils = double(load("res://Utils/runtime_utils.gd")).new()
	stub(runtime_utils, "is_authority").to_return(is_authority)
	bullet._runtime_utils = runtime_utils
	# when
	bullet._on_body_entered(body)
	# then
	if is_authority and is_player:
		assert_called(body, "hurt")
	else:
		assert_not_null(body) # kind of useless. Just to check if the code runs well everywhere, especially around the queue free
	# cleanup 
	body.free()

var on_SceneUtils_toggle_scene_freeze_params := [
	[true],
	[false]
]
func test_on_SceneUtils_toggle_scene_freeze_params(params = use_parameters(on_SceneUtils_toggle_scene_freeze_params)):
	# given
	var freeze = params[0]
	# when
	bullet._on_SceneUtils_toggle_scene_freeze(freeze)
	# then
	assert_eq(bullet.freeze, freeze)
