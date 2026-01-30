extends "res://addons/gut/test.gd"
##### TESTS #####
func test_get_handler():
	for handler in range(0, StaticActionHandler.handlers.size()):
		# given
		# when
		var res = StaticActionHandler.get_handler(handler)
		# then
		assert_not_null(res)
		# cleanup
		res.free()
