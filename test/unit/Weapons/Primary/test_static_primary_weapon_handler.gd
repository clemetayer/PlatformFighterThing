extends "res://addons/gut/test.gd"
##### TESTS #####
func test_get_weapon():
	for handler in range(0, StaticPrimaryWeaponHandler.handlers.size()):
		# given
		# when
		var res = StaticPrimaryWeaponHandler.get_weapon(handler)
		# then
		assert_not_null(res)
		# cleanup 
		res.free()

func test_get_icon_path():
	for handler in range(0, StaticPrimaryWeaponHandler.handlers.size()):
		# given
		# when
		var res = StaticPrimaryWeaponHandler.get_icon_path(handler)
		# then
		assert_not_null(res)
