extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var scene
var _sender = InputSender.new(Input)
var toggle_scene_freeze_times_called := 0
var toggle_scene_freeze_args := []

##### SETUP #####
func before_each():
	SceneUtils.connect("toggle_scene_freeze", _on_toggle_scene_freeze)
	toggle_scene_freeze_times_called = 0
	toggle_scene_freeze_args = []
	scene = load("res://test/integration/Parry/scene_parry.tscn").instantiate()
	add_child_autofree(scene)
	await wait_frames(1)
	await wait_seconds(1.0) # waits 1s to make sure the player is initialized and on the floor

##### TEARDOWN #####
func after_each():
	_sender.release_all()
	_sender.clear()

##### TESTS #####
func test_parry_lockout():
	# given
	# when / then
	_sender.action_down("parry").hold_for(.1)
	await(_sender.idle)
	assert_true(scene.is_parrying())
	assert_false(scene.is_parry_lockout())
	await(wait_seconds(0.25))
	assert_false(scene.is_parrying())
	assert_true(scene.is_parry_lockout())
	_sender.action_down("parry").hold_for(.1)
	await(_sender.idle)
	assert_false(scene.is_parrying())
	assert_true(scene.is_parry_lockout())
	await(wait_seconds(0.5))
	assert_false(scene.is_parrying())
	assert_false(scene.is_parry_lockout())
	_sender.action_down("parry").hold_for(.1)
	await(_sender.idle)
	assert_true(scene.is_parrying())
	assert_false(scene.is_parry_lockout())

func test_parry_bullet():
	# given
	var bullet = load("res://Scenes/Weapons/Projectiles/bullet.tscn").instantiate()
	bullet.init_position = scene.get_fire_position()
	bullet.init_rotation = 0.0
	var previous_owner = Node2D.new()
	bullet.current_owner = previous_owner
	scene.fire_projectile(bullet)
	# when / then
	await wait_seconds(0.1)
	_sender.action_down("parry").hold_for(.1)
	await(_sender.idle)
	await wait_seconds(0.25)
	assert_false(scene.is_parry_lockout())
	assert_ne(bullet.rotation, 0.0)
	assert_eq(bullet.speed, 2 * bullet.SPEED)
	assert_eq(bullet.damage, 2 * bullet.DAMAGE)
	assert_eq(bullet.knockback, 2 * bullet.KNOCKBACK)
	assert_eq(toggle_scene_freeze_times_called, 2)
	assert_eq(toggle_scene_freeze_args, [[true],[false]])
	assert_eq(bullet.current_owner, scene.get_player())
	# cleanup
	previous_owner.free()
	bullet.free()
	
##### UTILS #####
func _on_toggle_scene_freeze(value : bool) -> void:
	toggle_scene_freeze_times_called += 1
	toggle_scene_freeze_args.append([value])
