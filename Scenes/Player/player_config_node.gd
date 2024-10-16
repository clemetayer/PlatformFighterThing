extends Node
# Used to load the player's config and to be synced in multiplayer

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
@export var CONFIG : PlayerConfig
@export var ACTION_HANDLER : StaticActionHandlerStrategy.handlers
@export var PRIMARY_WEAPON : StaticPrimaryWeaponHandler.weapons
@export var MOVEMENT_BONUS_HANDLER : StaticMovementBonusHandler.handlers
@export var POWERUP_HANDLER : StaticPowerupHandler.handlers
@export var SPRITE_CUSTOMIZATION : SpriteCustomizationResource


#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
# onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	ACTION_HANDLER = CONFIG.ACTION_HANDLER
	PRIMARY_WEAPON = CONFIG.PRIMARY_WEAPON
	MOVEMENT_BONUS_HANDLER = CONFIG.MOVEMENT_BONUS_HANDLER
	POWERUP_HANDLER = CONFIG.POWERUP_HANDLER
	SPRITE_CUSTOMIZATION = CONFIG.SPRITE_CUSTOMIZATION

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
