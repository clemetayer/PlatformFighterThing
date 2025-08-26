extends "res://addons/gut/test.gd"

##### TESTS #####
var cubic_ease_out_params := [
	[0.1, 0.271],
	[0.75, 0.984],
	[2.0,1.0]
]
func test_cubic_ease(params = use_parameters(cubic_ease_out_params)):
	# given
	var x = params[0]
	var expected_res = params[1]
	# when
	var res = StaticUtils.cubic_ease_out(x)
	# then
	assert_almost_eq(res, expected_res,0.01)

var map_if_exists_params := [
	[{"modulate":Color.AQUA}, true],
	[{"does_not_exist":1}, false]
]
func test_map_if_exists(params = use_parameters(map_if_exists_params)):
	# given
	var data = params[0]
	var exists = params[1]
	var obj = Node2D.new()
	# when
	StaticUtils.map_if_exists(data, "modulate", obj, "modulate")
	# then
	if exists:
		assert_eq(obj.modulate, Color.AQUA)
	else:
		assert_not_null(obj) # just a fail check, not really usefull here
	# cleanup
	obj.free()
