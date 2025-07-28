extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var triangle_city
var runtime_config

##### SETUP #####
func before_each():
	triangle_city = load("res://Scenes/Levels/Backgrounds/TriangleCity/triangle_city.gd").new()
	mock_runtime_config()

##### TEARDOWN #####
func after_each():
	triangle_city._runtime_config.free()
	triangle_city.free()

##### TESTS #####
var handle_arpeggios_params := [
	[RuntimeConfig.VISUAL_INTENSITY.LOW, true, false],
	[RuntimeConfig.VISUAL_INTENSITY.MID, true, true],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, true, true],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, false, false]
]
func test_handle_arpeggios(params = use_parameters(handle_arpeggios_params)):
	# given
	runtime_config.visual_intensity = params[0]
	var song = load("res://Audio/BGM/FittingTitle/fitting_title.gd").new()
	song.ARPEGGIO_ACTIVE = params[1]
	triangle_city.onready_paths = {
		"particles": {
			"arpeggios": GPUParticles2D.new()
		},
		"song": song
	}
	triangle_city.onready_paths.particles.arpeggios.emitting = false
	# when
	triangle_city._handle_arpeggios()
	# then
	assert_eq(triangle_city.onready_paths.particles.arpeggios.emitting, params[2])
	# cleanup 
	song.free()
	triangle_city.onready_paths.particles.arpeggios.free()

var handle_drone_1_octave_up_params := [
	[RuntimeConfig.VISUAL_INTENSITY.LOW, true, false],
	[RuntimeConfig.VISUAL_INTENSITY.MID, true, false],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, true, true],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, false, false]
]
func test_handle_drone_1_octave_up(params = use_parameters(handle_drone_1_octave_up_params)):
	# given
	runtime_config.visual_intensity = params[0]
	var song = load("res://Audio/BGM/FittingTitle/fitting_title.gd").new()
	song.DRONE_1_OCTAVE_UP_ACTIVE = params[1]
	triangle_city.onready_paths = {
		"standalone": {
			"saw_wave": Sprite2D.new()
		},
		"song": song
	}
	triangle_city.onready_paths.standalone.saw_wave.visible = false
	# when
	triangle_city._handle_drone_1_octave_up()
	# then
	assert_eq(triangle_city.onready_paths.standalone.saw_wave.visible, params[2])
	# cleanup 
	song.free()
	triangle_city.onready_paths.standalone.saw_wave.free()

var on_fitting_title_c_hat_params := [
	[RuntimeConfig.VISUAL_INTENSITY.LOW, false],
	[RuntimeConfig.VISUAL_INTENSITY.MID, true],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, true],
]
func test_on_fitting_title_c_hat(params = use_parameters(on_fitting_title_c_hat_params)):
	# given
	runtime_config.visual_intensity = params[0]
	triangle_city.onready_paths = {
		"animation": {
			"spotlights_mid": double(AnimationPlayer).new()
		}
	}
	stub(triangle_city.onready_paths.animation.spotlights_mid, "play").to_do_nothing()
	# when
	triangle_city._on_fitting_title_c_hat()
	# then
	if params[1]:
		assert_called(triangle_city.onready_paths.animation.spotlights_mid, "play", ["flash", null, null, null])
	else:
		assert_not_called(triangle_city.onready_paths.animation.spotlights_mid, "play")

var on_fitting_title_drone_1_params := [
	[RuntimeConfig.VISUAL_INTENSITY.LOW, false],
	[RuntimeConfig.VISUAL_INTENSITY.MID, true],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, true],
]
func test_on_fitting_title_drone_1(params = use_parameters(on_fitting_title_drone_1_params)):
	# given
	runtime_config.visual_intensity = params[0]
	triangle_city.onready_paths = {
		"animation": {
			"back_buildings": double(AnimationPlayer).new(),
			"front_buildings": double(AnimationPlayer).new()
		}
	}
	stub(triangle_city.onready_paths.animation.back_buildings, "play").to_do_nothing()
	stub(triangle_city.onready_paths.animation.front_buildings, "play").to_do_nothing()
	# when
	triangle_city._on_fitting_title_drone_1()
	# then
	if params[1]:
		assert_called(triangle_city.onready_paths.animation.back_buildings, "play", ["flash", null, null, null])
		assert_called(triangle_city.onready_paths.animation.front_buildings, "play", ["flash", null, null, null])
	else:
		assert_not_called(triangle_city.onready_paths.animation.back_buildings, "play")
		assert_not_called(triangle_city.onready_paths.animation.front_buildings, "play")

var on_fitting_title_drone_2_params := [
	[RuntimeConfig.VISUAL_INTENSITY.LOW, false],
	[RuntimeConfig.VISUAL_INTENSITY.MID, false],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, true],
]
func test_on_fitting_title_drone_2(params = use_parameters(on_fitting_title_drone_2_params)):
	# given
	runtime_config.visual_intensity = params[0]
	triangle_city.onready_paths = {
		"animation": {
			"flashing_front": double(AnimationPlayer).new()
		}
	}
	stub(triangle_city.onready_paths.animation.flashing_front, "play").to_do_nothing()
	# when
	triangle_city._on_fitting_title_drone_2()
	# then
	if params[1]:
		assert_called(triangle_city.onready_paths.animation.flashing_front, "play", ["flash", null, null, null])
	else:
		assert_not_called(triangle_city.onready_paths.animation.flashing_front, "play")

var on_fitting_title_kick_params := [
	[RuntimeConfig.VISUAL_INTENSITY.LOW, false],
	[RuntimeConfig.VISUAL_INTENSITY.MID, true],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, true],
]
func test_on_fitting_title_kick(params = use_parameters(on_fitting_title_kick_params)):
	# given
	runtime_config.visual_intensity = params[0]
	triangle_city.onready_paths = {
		"animation": {
			"glow": double(AnimationPlayer).new()
		}
	}
	stub(triangle_city.onready_paths.animation.glow, "play").to_do_nothing()
	# when
	triangle_city._on_fitting_title_kick()
	# then
	if params[1]:
		assert_called(triangle_city.onready_paths.animation.glow, "play", ["grow", null, null, null])
	else:
		assert_not_called(triangle_city.onready_paths.animation.glow, "play")

var on_fitting_title_lead_params := [
	[RuntimeConfig.VISUAL_INTENSITY.LOW, false],
	[RuntimeConfig.VISUAL_INTENSITY.MID, false],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, true],
]
func test_on_fitting_title_lead(params = use_parameters(on_fitting_title_lead_params)):
	# given
	runtime_config.visual_intensity = params[0]
	triangle_city.onready_paths = {
		"particles": {
			"lead": double(load("res://Scenes/Levels/Backgrounds/TriangleCity/lead.gd")).new()
		}
	}
	stub(triangle_city.onready_paths.particles.lead, "spawn_sprite").to_do_nothing()
	# when
	triangle_city._on_fitting_title_lead()
	# then
	if params[1]:
		assert_called(triangle_city.onready_paths.particles.lead, "spawn_sprite")
	else:
		assert_not_called(triangle_city.onready_paths.particles.lead, "spawn_sprite")

var on_fitting_title_o_hat_params := [
	[RuntimeConfig.VISUAL_INTENSITY.LOW, false],
	[RuntimeConfig.VISUAL_INTENSITY.MID, true],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, true],
]
func test_on_fitting_title_o_hat(params = use_parameters(on_fitting_title_o_hat_params)):
	# given
	runtime_config.visual_intensity = params[0]
	triangle_city.onready_paths = {
		"animation": {
			"spotlights_front": double(AnimationPlayer).new()
		}
	}
	stub(triangle_city.onready_paths.animation.spotlights_front, "play").to_do_nothing()
	# when
	triangle_city._on_fitting_title_o_hat()
	# then
	if params[1]:
		assert_called(triangle_city.onready_paths.animation.spotlights_front, "play", ["flash", null, null, null])
	else:
		assert_not_called(triangle_city.onready_paths.animation.spotlights_front, "play")

var on_fitting_title_piano_params := [
	[RuntimeConfig.VISUAL_INTENSITY.LOW, 0, false],
	[RuntimeConfig.VISUAL_INTENSITY.MID, 1, false],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, 2, true],
]
func test_on_fitting_title_piano(params = use_parameters(on_fitting_title_piano_params)):
	# given
	runtime_config.visual_intensity = params[0]
	triangle_city.onready_paths = {
		"animation": {
			"triangle_group": {
				0 : double(AnimationPlayer).new(),
				1 : double(AnimationPlayer).new(),
				2 : double(AnimationPlayer).new()
			}
		}
	}
	stub(triangle_city.onready_paths.animation.triangle_group[params[1]], "play").to_do_nothing()
	triangle_city._piano_cnt = params[1]
	# when
	triangle_city._on_fitting_title_piano()
	# then
	if params[2]:
		assert_called(triangle_city.onready_paths.animation.triangle_group[params[1]], "play", ["flash", null, null, null])
	else:
		assert_not_called(triangle_city.onready_paths.animation.triangle_group[params[1]], "play")
	triangle_city._piano_cnt = (params[1] + 1) % 3

var on_fitting_title_snare_params := [
	[RuntimeConfig.VISUAL_INTENSITY.LOW, false],
	[RuntimeConfig.VISUAL_INTENSITY.MID, false],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, true],
]
func test_on_fitting_title_snare(params = use_parameters(on_fitting_title_snare_params)):
	# given
	runtime_config.visual_intensity = params[0]
	triangle_city.onready_paths = {
		"animation": {
			"background": double(AnimationPlayer).new()
		}
	}
	stub(triangle_city.onready_paths.animation.background, "play").to_do_nothing()
	# when
	triangle_city._on_fitting_title_snare()
	# then
	if params[1]:
		assert_called(triangle_city.onready_paths.animation.background, "play", ["flash", null, null, null])
	else:
		assert_not_called(triangle_city.onready_paths.animation.background, "play")

var on_fitting_title_drone_1_octave_up_params := [
	[RuntimeConfig.VISUAL_INTENSITY.LOW, false],
	[RuntimeConfig.VISUAL_INTENSITY.MID, false],
	[RuntimeConfig.VISUAL_INTENSITY.HIGH, true],
]
func test_on_fitting_title_drone_1_octave_up(params = use_parameters(on_fitting_title_drone_1_octave_up_params)):
	# given
	runtime_config.visual_intensity = params[0]
	triangle_city.onready_paths = {
		"animation": {
			"saw_wave": double(AnimationPlayer).new()
		}
	}
	stub(triangle_city.onready_paths.animation.saw_wave, "play").to_do_nothing()
	# when
	triangle_city._on_fitting_title_drone_1_octave_up()
	# then
	if params[1]:
		assert_called(triangle_city.onready_paths.animation.saw_wave, "play", ["fade_in", null, null, null])
	else:
		assert_not_called(triangle_city.onready_paths.animation.saw_wave, "play")

##### UTILS #####
func mock_runtime_config():
	runtime_config = load("res://Utils/Config/runtime_config.gd").new()
	triangle_city._runtime_config = runtime_config
