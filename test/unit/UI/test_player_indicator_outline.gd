extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var indicator


##### SETUP #####
func before_each():
	indicator = load("res://Scenes/UI/PlayersData/PlayerData/player_indicator_outline.gd").new()


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
