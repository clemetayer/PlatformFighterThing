extends "res://addons/gut/test.gd"

##### TESTS #####
func test_get_primary_weapons_descriptions():
	# given
	# when
	var res = StaticItemDescriptions.get_primary_weapons_descriptions()
	# then
	assert_eq(res.size(), StaticItemDescriptions.PRIMARY_WEAPONS.keys().size())
	for element in res:
		assert_not_null(element.ITEM_ID)
		assert_not_null(element.ICON_PATH)
		assert_not_null(element.NAME)
		assert_not_null(element.DESCRIPTION)

func test_get_movement_bonus_descriptions():
	# given
	# when
	var res = StaticItemDescriptions.get_movement_bonus_descriptions()
	# then
	assert_eq(res.size(), StaticItemDescriptions.MOVEMENT_BONUS.keys().size())
	for element in res:
		assert_not_null(element.ITEM_ID)
		assert_not_null(element.ICON_PATH)
		assert_not_null(element.NAME)
		assert_not_null(element.DESCRIPTION)

func test_get_powerups_descriptions():
	# given
	# when
	var res = StaticItemDescriptions.get_powerups_descriptions()
	# then
	assert_eq(res.size(), StaticItemDescriptions.POWERUPS.keys().size())
	for element in res:
		assert_not_null(element.ITEM_ID)
		assert_not_null(element.ICON_PATH)
		assert_not_null(element.NAME)
		assert_not_null(element.DESCRIPTION)