extends "res://addons/gut/test.gd"

##### TESTS #####
func test_set_element():
	# given
	# when
	var res = ItemGridMenuElement.set_element(1, "icon_path", "name", "description")
	# then
	assert_eq(res.ITEM_ID, 1)
	assert_eq(res.ICON_PATH, "icon_path")
	assert_eq(res.NAME, "name")
	assert_eq(res.DESCRIPTION, "description")
	# cleanup
	res.free()
