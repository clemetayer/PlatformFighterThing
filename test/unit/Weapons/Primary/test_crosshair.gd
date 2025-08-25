extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var crosshair

##### SETUP #####
func before_each():
	crosshair = load("res://Scenes/Weapons/Primary/crosshair.gd").new()

##### TEARDOWN #####
func after_each():
	crosshair.free()

##### TESTS #####
func test_set_color():
	# given
	crosshair.modulate = Color.WHITE
	# when
	crosshair.set_color(Color.ANTIQUE_WHITE)
	# then
	assert_eq(crosshair.modulate, Color.ANTIQUE_WHITE)
