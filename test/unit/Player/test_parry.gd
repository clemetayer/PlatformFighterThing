extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var parry

##### SETUP #####
func before_each():
	parry = load("res://Scenes/Player/parry.gd").new()

##### TEARDOWN #####
func after_each():
	parry.free()

##### TESTS #####
var toggle_parry_params := [
	[true],
	[false]
]
func test_toggle_parry(params = use_parameters(toggle_parry_params)):
	# given
	# when
	parry.toggle_parry(params[0])
	# then
	assert_eq(parry._enabled, params[0])

var parry_params := [
	[false, false],
	[true, false],
	[true, true]
]
func test_parry(params = use_parameters(parry_params)):
	# given
	var enabled = params[0]
	var can_parry = params[1]
	parry._enabled = enabled
	parry._can_parry = can_parry
	parry._parrying = false
	parry.monitoring = false
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	var parry_timer = double(Timer).new()
	stub(parry_timer, "start").to_do_nothing()
	parry.onready_paths.parry_timer = parry_timer
	var animation_player = double(AnimationPlayer).new()
	stub(animation_player, "play").to_do_nothing()
	parry.onready_paths.animation_player = animation_player
	var parry_active_sound = double(AudioStreamPlayer).new()
	stub(parry_active_sound, "play").to_do_nothing()
	onready_paths_node.parry_active_sound = parry_active_sound
	var parry_wrong = double(AudioStreamPlayer).new()
	stub(parry_wrong, "play").to_do_nothing()
	onready_paths_node.parry_wrong = parry_wrong
	parry.onready_paths_node = onready_paths_node
	# when
	parry.parry()
	# then
	if enabled:
		if can_parry:
			assert_true(parry._parrying)
			assert_true(parry.monitoring)
			assert_called(parry_timer, "start")
			assert_called(animation_player, "play", ["parrying", null, null, null])
			assert_called(parry_active_sound, "play")
			assert_not_called(parry_wrong, "play")
		else:
			assert_false(parry._parrying)
			assert_false(parry.monitoring)
			assert_not_called(parry_timer, "start")
			assert_not_called(animation_player, "play", ["parrying", null, null, null])
			assert_not_called(parry_active_sound, "play")
			assert_called(parry_wrong, "play")
	else:
		assert_false(parry._parrying)
		assert_false(parry.monitoring)
		assert_not_called(parry_timer, "start")
		assert_not_called(animation_player, "play", ["parrying", null, null, null])
		assert_not_called(parry_active_sound, "play")
		assert_not_called(parry_wrong, "play")
	# cleanup
	onready_paths_node.free()

func test_on_lockout_timer_timeout():
	# given
	parry._can_parry = false
	# when
	parry._on_lockout_timer_timeout()
	# then
	assert_true(parry._can_parry)

func test_on_parry_timer_timeout():
	# given
	parry._can_parry = true
	parry._parrying = true
	parry.monitoring = true
	var animation_player = double(AnimationPlayer).new()
	stub(animation_player, "play").to_do_nothing()
	parry.onready_paths.animation_player = animation_player
	var lockout_timer = double(Timer).new()
	stub(lockout_timer, "start").to_do_nothing()
	parry.onready_paths.lockout_timer = lockout_timer
	# when
	parry._on_parry_timer_timeout()
	# then
	assert_false(parry._can_parry)
	assert_false(parry._parrying)
	assert_false(parry.monitoring)
	assert_called(animation_player, "play", ["parry_lockout", null, null, null])
	assert_called(lockout_timer, "start")
