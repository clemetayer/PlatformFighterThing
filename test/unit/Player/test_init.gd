extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var init

##### SETUP #####
func before_each():
	init = load("res://Scenes/Player/init.gd").new()

##### TEARDOWN #####
func after_each():
	init.free()

##### TESTS #####
func test_initialize():
	# given
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	var input_synchronizer = double(load("res://Scenes/Player/input_synchronizer.gd")).new()
	onready_paths_node.input_synchronizer = input_synchronizer
	stub(input_synchronizer, "start_input_detection").to_do_nothing()
	stub(input_synchronizer, "set_action_handler").to_do_nothing()
	var sprites = double(load("res://Scenes/Player/sprites.gd")).new()
	onready_paths_node.sprites = sprites
	stub(sprites, "load_sprite_preset").to_do_nothing()
	var crosshair = double(load("res://Scenes/Weapons/Primary/crosshair.gd")).new()
	onready_paths_node.crosshair = crosshair
	stub(crosshair, "set_color").to_do_nothing()
	var damage_label = double(load("res://Scenes/Player/damage_text.gd")).new()
	stub(damage_label, "init_damage").to_do_nothing()
	onready_paths_node.damage_label = damage_label
	var death_manager = double(load("res://Scenes/Player/death_manager.gd")).new()
	stub(death_manager, "set_particles_color").to_do_nothing()
	onready_paths_node.death_manager = death_manager
	var appear_elements = double(load("res://Scenes/Player/appear_elements.gd")).new()
	stub(appear_elements, "init").to_do_nothing()
	onready_paths_node.appear_elements = appear_elements
	var player_root = Node2D.new()
	onready_paths_node.player_root = player_root
	add_child(player_root)
	wait_for_signal(player_root.tree_entered, 0.25)
	init.onready_paths_node = onready_paths_node
	# when
	var config = generate_test_config()
	init.initialize(config)
	wait_frames(2)
	# then
	assert_called(input_synchronizer, "start_input_detection")
	assert_called(sprites, "load_sprite_preset", [config.SPRITE_CUSTOMIZATION])
	assert_eq(init.ACTION_HANDLER, config.ACTION_HANDLER)
	assert_eq(init.PRIMARY_WEAPON, config.PRIMARY_WEAPON)
	assert_eq(init.MOVEMENT_BONUS_HANDLER, config.MOVEMENT_BONUS_HANDLER)
	assert_eq(init.POWERUP_HANDLER, config.POWERUP_HANDLER)
	assert_called(crosshair, "set_color", [Color.REBECCA_PURPLE])
	assert_not_null(onready_paths_node.primary_weapon)
	assert_not_null(onready_paths_node.movement_bonus)
	assert_not_null(onready_paths_node.powerup_manager)
	assert_called(input_synchronizer, "set_action_handler", [config.ACTION_HANDLER])
	assert_eq(onready_paths_node.movement_bonus.player, player_root)
	assert_eq(onready_paths_node.primary_weapon.projectile_owner, player_root)
	assert_called(damage_label, "init_damage")
	assert_eq(onready_paths_node.primary_weapon.owner_color, Color.REBECCA_PURPLE)
	assert_called(death_manager, "set_particles_color", [Color.ANTIQUE_WHITE])
	assert_called(appear_elements, "init", [Color.REBECCA_PURPLE, Color.ANTIQUE_WHITE])
	assert_eq(player_root.get_child_count(), 3)
	assert_true(onready_paths_node.movement_bonus.has_connections("value_updated"))
	assert_true(onready_paths_node.powerup_manager.has_connections("value_updated"))
	# cleanup
	player_root.free()
	onready_paths_node.free()

##### UTILS #####
func generate_test_config() -> PlayerConfig:
	var config = PlayerConfig.new()
	var sprite_customization = SpriteCustomizationResource.new()
	sprite_customization.BODY_COLOR = Color.REBECCA_PURPLE
	sprite_customization.OUTLINE_COLOR = Color.ANTIQUE_WHITE
	config.ACTION_HANDLER = StaticActionHandler.handlers.INPUT
	config.PRIMARY_WEAPON = StaticPrimaryWeaponHandler.handlers.REVOLVER
	config.MOVEMENT_BONUS_HANDLER = StaticMovementBonusHandler.handlers.DASH
	config.POWERUP_HANDLER = StaticPowerupHandler.handlers.SPLITTER
	config.SPRITE_CUSTOMIZATION = sprite_customization
	config.ELIMINATION_TEXT = "haha"
	return config
