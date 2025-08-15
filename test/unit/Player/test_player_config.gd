extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var player_config

##### SETUP #####
func before_each():
	player_config = PlayerConfig.new()

##### TESTS #####
func test_serialize():
	# given
	player_config.ACTION_HANDLER = StaticActionHandlerStrategy.handlers.BASE
	player_config.PRIMARY_WEAPON = StaticPrimaryWeaponHandler.weapons.REVOLVER
	player_config.MOVEMENT_BONUS_HANDLER = StaticMovementBonusHandler.handlers.BASE
	player_config.POWERUP_HANDLER = StaticPowerupHandler.handlers.SPLITTER
	var sprite_customization = SpriteCustomizationResource.new()
	sprite_customization.BODY_COLOR = Color.AQUAMARINE
	sprite_customization.OUTLINE_COLOR = Color.BISQUE
	player_config.SPRITE_CUSTOMIZATION = sprite_customization
	player_config.ELIMINATION_TEXT = "test"
	var expected = {
        "action_handler":StaticActionHandlerStrategy.handlers.BASE,
        "primary_weapon":StaticPrimaryWeaponHandler.weapons.REVOLVER,
        "movement_bonus_handler":StaticMovementBonusHandler.handlers.BASE,
        "powerup_handler":StaticPowerupHandler.handlers.SPLITTER,
        "sprite_customization": {
			"body_color": Color.AQUAMARINE.to_html(),
			"outline_color": Color.BISQUE.to_html()
		},
        "elimination_text":"test"
    }
	# when
	var res = player_config.serialize()
	# then
	assert_eq(res,expected)

func test_deserialize():
	# given
	var data = {
        "action_handler":StaticActionHandlerStrategy.handlers.BASE,
        "primary_weapon":StaticPrimaryWeaponHandler.weapons.REVOLVER,
        "movement_bonus_handler":StaticMovementBonusHandler.handlers.BASE,
        "powerup_handler":StaticPowerupHandler.handlers.SPLITTER,
        "sprite_customization": {
			"body_color": Color.AQUAMARINE.to_html(),
			"outline_color": Color.BISQUE.to_html()
		},
        "elimination_text":"test"
    }
	# when
	player_config.deserialize(data)
	# then
	assert_eq(player_config.ACTION_HANDLER, StaticActionHandlerStrategy.handlers.BASE)
	assert_eq(player_config.PRIMARY_WEAPON, StaticPrimaryWeaponHandler.weapons.REVOLVER)
	assert_eq(player_config.MOVEMENT_BONUS_HANDLER, StaticPowerupHandler.handlers.SPLITTER)
	assert_eq(player_config.SPRITE_CUSTOMIZATION.BODY_COLOR, Color.AQUAMARINE)
	assert_eq(player_config.SPRITE_CUSTOMIZATION.OUTLINE_COLOR, Color.BISQUE)
	assert_eq(player_config.ELIMINATION_TEXT, "test")

