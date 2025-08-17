extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var sgm

##### SETUP #####
func before_each():
	sgm = load("res://Scenes/UI/ScreenGameMessage/screen_game_message.gd").new()

##### TEARDOWN #####
func after_each():
	sgm.free()

##### TESTS #####
func test_init():
	# given
	var label = Label.new()
	sgm.onready_paths.label = label
	label.text = "test"
	# when
	sgm.init()
	# then
	assert_eq(label.text, "")
	# cleanup
	label.free()

var display_message_params := [
	[true],
	[false]
]
func test_display_message(params = use_parameters(display_message_params)):
	# given
	var display_all_characters = params[0]
	var label = Label.new()
	var animation = double(AnimationPlayer).new()
	stub(animation, "play").to_do_nothing()
	var mid_screen_timer = Timer.new()
	sgm.onready_paths.label = label
	sgm.onready_paths.animation = animation
	sgm.onready_paths.mid_screen_timer = mid_screen_timer
	# when
	sgm.display_message("test", 2.0, display_all_characters)
	# then
	assert_eq(label.text, "test")
	assert_called(animation, "play", ["enter", null, null, null])
	if display_all_characters:
		assert_eq(label.visible_characters, -1)
	else:
		assert_eq(label.visible_ratio, 0)
		assert_not_null(sgm._display_characters_tween)
	assert_eq(mid_screen_timer.wait_time, 2.0 - (sgm.ENTER_ANIM_TIME + sgm.EXIT_ANIM_TIME))
	# cleanup
	label.free()
	mid_screen_timer.free()

var on_animation_player_animation_finished_params := [
	["enter"],
	["not_enter"]
]
func test_on_animation_player_animation_finished(params = use_parameters(on_animation_player_animation_finished_params)):
	# given
	var anim_name = params[0]
	var timer = double(Timer).new()
	stub(timer, "start").to_do_nothing()
	sgm.onready_paths.mid_screen_timer = timer
	# when
	sgm._on_animation_player_animation_finished(anim_name)
	# then
	if anim_name == "enter":
		assert_called(timer, "start")
	else:
		assert_not_called(timer, "start")

func test_on_mid_screen_timer_timeout():
	# given
	var animation = double(AnimationPlayer).new()
	stub(animation, "play").to_do_nothing()
	sgm.onready_paths.animation = animation
	# when
	sgm._on_mid_screen_timer_timeout()
	# then
	assert_called(animation, "play", ["exit", null, null, null])

