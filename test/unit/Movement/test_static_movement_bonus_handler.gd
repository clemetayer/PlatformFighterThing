extends "res://addons/gut/test.gd"

##### TESTS #####
func test_get_handler():
	for handler in range(0, StaticMovementBonusHandler.handlers.size()):
		# given
		# when
		var res = StaticMovementBonusHandler.get_handler(handler)
		# then
		assert_not_null(res)
		# cleanup
		res.free()

func test_get_icon_path():
	for handler in range(0, StaticMovementBonusHandler.handlers.size()):
		# given
		# when
		var res = StaticMovementBonusHandler.get_icon_path(handler)
		# then
		assert_not_null(res)

func test_get_ui_scene():
	for handler in range(0, StaticMovementBonusHandler.handlers.size()):
		# given
		# when
		var res = StaticMovementBonusHandler.get_ui_scene(handler)
		# then
		assert_not_null(res)
		# cleanup
		res.free()
