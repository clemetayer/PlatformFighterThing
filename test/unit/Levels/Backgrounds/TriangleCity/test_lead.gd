extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var lead

##### SETUP #####
func before_each():
	lead = load("res://Scenes/Levels/Backgrounds/TriangleCity/lead.gd").new()

##### TEARDOWN #####
func after_each():
	lead.free()

##### TESTS #####
func test_spawn_sprite():
	# given
	lead.GRADIENT = GradientTexture1D.new()
	lead.GRADIENT.gradient = _mock_gradient()
	add_child(lead)
	wait_for_signal(lead.tree_entered, 0.25)
	# when
	lead.spawn_sprite()
	# then
	wait_seconds(0.25)
	assert_eq(lead.get_child_count(), 1)

##### UTILS #####
func _mock_gradient():
	var gradient = Gradient.new()
	gradient.remove_point(0)	
	gradient.add_point(0, Color.RED)
	gradient.add_point(1, Color.GREEN)
	gradient.remove_point(0)
	return gradient
