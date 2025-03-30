extends Node
# Tool to initalize the player's config

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths_node := $"../Paths"
@export var ACTION_HANDLER : StaticActionHandlerStrategy.handlers
@export var PRIMARY_WEAPON : StaticPrimaryWeaponHandler.weapons
@export var MOVEMENT_BONUS_HANDLER : StaticMovementBonusHandler.handlers
@export var POWERUP_HANDLER : StaticPowerupHandler.handlers

##### PUBLIC METHODS #####
func initialize(config : PlayerConfig) -> void:
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		onready_paths_node.sprites.load_sprite_preset(config.SPRITE_CUSTOMIZATION)
		ACTION_HANDLER = config.ACTION_HANDLER
		PRIMARY_WEAPON = config.PRIMARY_WEAPON
		MOVEMENT_BONUS_HANDLER = config.MOVEMENT_BONUS_HANDLER
		POWERUP_HANDLER = config.POWERUP_HANDLER
		onready_paths_node.crosshair.set_color(config.SPRITE_CUSTOMIZATION.BODY_COLOR)
	onready_paths_node.primary_weapon = StaticPrimaryWeaponHandler.get_weapon(PRIMARY_WEAPON)
	onready_paths_node.movement_bonus = StaticMovementBonusHandler.get_handler(MOVEMENT_BONUS_HANDLER)
	onready_paths_node.powerup_manager = StaticPowerupHandler.get_powerup_manager(POWERUP_HANDLER)
	onready_paths_node.input_synchronizer.set_action_handler(ACTION_HANDLER)
	onready_paths_node.movement_bonus.player = onready_paths_node.player_root
	onready_paths_node.primary_weapon.projectile_owner = onready_paths_node.player_root
	onready_paths_node.damage_label.text = "%f" % onready_paths_node.player_root.DAMAGE
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		onready_paths_node.primary_weapon.owner_color = config.SPRITE_CUSTOMIZATION.BODY_COLOR
	onready_paths_node.player_root.add_child(onready_paths_node.primary_weapon)
	onready_paths_node.player_root.add_child(onready_paths_node.movement_bonus)
	onready_paths_node.player_root.add_child(onready_paths_node.powerup_manager)
	onready_paths_node.death_manager.set_particles_color(config.SPRITE_CUSTOMIZATION.OUTLINE_COLOR)

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
