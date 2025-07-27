extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var level_bounds
var kill_times_called := 0

##### SETUP #####
func before_each():
	level_bounds = load("res://Scenes/LevelBounds/level_bounds.gd").new()
	kill_times_called = 0 

##### TEARDOWN #####
func after_each():
	level_bounds.free()

##### TESTS #####
var body_exited_params := [
	["player",1],
	["not_player",0]
]
func test_body_exited(params = use_parameters(body_exited_params)):
	# given
	var body = load("res://test/unit/LevelBounds/body_mock.gd").new()
	add_child(body)
	wait_for_signal(body.tree_entered, 0.25)
	body.add_to_group(params[0])
	body.connect("kill_called",_on_kill_called)
	# when
	level_bounds._on_body_exited(body)
	# then
	assert_eq(kill_times_called, params[1])
	# cleanup
	body.free()


##### UTILS #####
func _on_kill_called() -> void:
	kill_times_called += 1
