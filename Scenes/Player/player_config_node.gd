extends Node
# Used to load the player's config and to be synced in multiplayer

##### VARIABLES #####
#---- EXPORTS -----
@export var CONFIG : PlayerConfig
@export var ACTION_HANDLER : StaticActionHandler.handlers
@export var PRIMARY_WEAPON : StaticPrimaryWeaponHandler.handlers
@export var MOVEMENT_BONUS_HANDLER : StaticMovementBonusHandler.handlers
@export var POWERUP_HANDLER : StaticPowerupHandler.handlers
@export var SPRITE_CUSTOMIZATION : SpriteCustomizationResource

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	ACTION_HANDLER = CONFIG.ACTION_HANDLER
	PRIMARY_WEAPON = CONFIG.PRIMARY_WEAPON
	MOVEMENT_BONUS_HANDLER = CONFIG.MOVEMENT_BONUS_HANDLER
	POWERUP_HANDLER = CONFIG.POWERUP_HANDLER
	SPRITE_CUSTOMIZATION = CONFIG.SPRITE_CUSTOMIZATION
