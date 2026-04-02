extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var level


##### SETUP #####
func before_each():
	level = load("res://Scenes/UI/PlayerCustomizationMenu/PresetsMenu/ai_level.tscn").instantiate()
	add_child_autofree(level)


##### TESTS #####
func test_set_level():
	# given
	# when
	level.set_level(3)
	# then
	assert_eq(level.text, "3")
	assert_ne(level.modulate, Color.WHITE)
