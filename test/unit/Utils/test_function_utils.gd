extends "res://addons/gut/test.gd"

##### TESTS #####
var in_between_params := [
	[0.2,0.1,0.4,true, true],
	[0.2,0.4,0.1,true, true],
	[0.1,-0.2,0.2,true, true],
	[0.5,0.4,0.1,true, false],
	[0.0,0.4,0.1,true, false],
	[0.1,0.4,0.1,true, false],
	[0.4,0.4,0.1,true, false],
	[0.4,0.4,0.1,false, true],
	[0.1,0.4,0.1,false, true]
]
func test_in_between(params = use_parameters(in_between_params)):
	# given
	var value = params[0]
	var compare1 = params[1]
	var compare2 = params[2]
	var strict = params[3]
	var expected_res = params[4]
	# when
	var res = FunctionUtils.in_between(value, compare1, compare2, strict)
	# then
	assert_eq(res, expected_res)
