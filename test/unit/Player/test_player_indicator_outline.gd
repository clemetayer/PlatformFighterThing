extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var indicator


##### SETUP #####
func before_each():
	indicator = load("res://Scenes/Player/player_indicator_outline.gd").new()


##### TEARDOWN #####
func after_each():
	indicator.free()


##### TESTS #####
func test_set_player_color():
	# given
	indicator.modulate = Color.WHITE
	for player_idx in range(4):
		# when
		indicator.set_player_color(player_idx)
		# then
		assert_eq(indicator.modulate, RuntimeUtils.PLAYER_INDICATOR_COLORS[player_idx])


func test_on_player_damage_received():
	# given
	var animation_player = AnimationPlayer.new()
	indicator.animation = animation_player
	# when
	indicator._on_player_damage_received(10.0, 150.0, Vector2.RIGHT)
	# then
	assert_eq(animation_player.speed_scale, 5.0)
	# cleanup
	animation_player.free()
