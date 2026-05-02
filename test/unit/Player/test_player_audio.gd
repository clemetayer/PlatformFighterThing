extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var audio


##### SETUP #####
func before_each():
	audio = load("res://Scenes/Player/player_audio.gd").new()


##### TEARDOWN #####
func after_each():
	audio.free()


##### TESTS #####
func test_on_player_damage_received():
	# given
	var hit = double(AudioStreamPlayer2D).new()
	stub(hit, "play").to_do_nothing()
	audio.hit = hit
	# when
	audio._on_player_damage_received(10.0, 15.0, Vector2.RIGHT)
	# then
	assert_called(hit, "play")
