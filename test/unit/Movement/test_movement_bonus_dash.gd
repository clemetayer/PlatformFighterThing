extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var mbd
var value_updated_times_called := 0
var value_updated_args := []

##### SETUP #####
func before_each():
	mbd = load("res://Scenes/Movement/MovementBonusDash/movement_bonus_dash.gd").new()
	value_updated_times_called = 0
	value_updated_args = []

##### TEARDOWN #####
func after_each():
	mbd.free()

##### TESTS #####
var emit_particles_params := [
	[true],
	[false]
]
func test_emit_particles(params = use_parameters(emit_particles_params)):
	# given
	var particles = GPUParticles2D.new()
	mbd.onready_paths.dash_particles = particles
	particles.emitting = params[0]
	# when
	mbd._emit_particles()
	# then
	assert_true(particles.emitting)
	# cleanup
	particles.free()

func test_play_sound():
	# given
	var sound = double(AudioStreamPlayer).new()
	stub(sound, "play").to_do_nothing()
	mbd.onready_paths.sound = sound
	# when
	mbd._play_sound()
	# then
	assert_called(sound,"play")

var activate_params := [
	[0, true, false],
	[1, false, false],
	[1, true, false],
	[1, true, true]
]
func test_activate(params = use_parameters(activate_params)):
	# given
	mbd.DASHES_AVAILABLE = params[0]
	mbd.active = params[1]
	var mock_player = double(load("res://Scenes/Player/player.gd")).new()
	stub(mock_player, "override_velocity").to_do_nothing()
	stub(mock_player, "get_direction").to_return(Vector2.RIGHT)
	mbd.player = mock_player
	mbd.connect("value_updated",_on_value_updated)
	var particles = GPUParticles2D.new()
	particles.emitting = false
	mbd.onready_paths.dash_particles = particles
	var sound = double(AudioStreamPlayer).new()
	stub(sound, "play").to_do_nothing()
	mbd.onready_paths.sound = sound
	var timer = double(Timer).new()
	mbd.onready_paths.reload_timer = timer
	stub(timer, "is_stopped").to_return(params[2])
	stub(timer, "start").to_do_nothing()
	# when
	mbd.activate()
	# then
	if params[0] > 0 and params[1]:
		assert_called(mock_player,"override_velocity", [Vector2.RIGHT * mbd.DASH_VELOCITY])
		assert_eq(mbd.DASHES_AVAILABLE, params[0] - 1)
		assert_eq(value_updated_times_called, 1)
		assert_eq(value_updated_args, [[params[0] - 1]])
		assert_true(particles.emitting)
		assert_called(sound, "play")
		if params[2]:
			assert_called(timer, "start")
		else:
			assert_not_called(timer, "start")
	else:
		assert_eq(value_updated_times_called, 0)
		assert_not_called(sound, "play")
		assert_false(particles.emitting)
		assert_not_called(mock_player,"override_velocity")
		assert_not_called(timer, "start")
	# cleanup
	particles.free()

var on_reload_dash_timer_timeout_params := [
	[1,true],
	[2,false]
]
func test_on_reload_dash_timer_timeout(params = use_parameters(on_reload_dash_timer_timeout_params)):
	# given
	mbd.DASHES_AVAILABLE = params[0] 
	mbd.connect("value_updated",_on_value_updated)
	var timer = double(Timer).new()
	stub(timer, "start").to_do_nothing()
	mbd.onready_paths.reload_timer = timer
	# when
	mbd._on_reload_dash_timer_timeout()
	# then
	assert_eq(mbd.DASHES_AVAILABLE, params[0] + 1)
	assert_eq(value_updated_times_called, 1)
	assert_eq(value_updated_args, [[params[0] + 1]])
	if params[1]:
		assert_called(timer,"start")
	else:
		assert_not_called(timer, "start")


##### UTILS #####
func _on_value_updated(value):
	value_updated_times_called += 1
	value_updated_args.append([value])
