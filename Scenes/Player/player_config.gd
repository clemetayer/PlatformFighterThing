extends Resource
class_name PlayerConfig
# Parameters to give to the player to fine tune it easily

##### VARIABLES #####
#---- EXPORTS -----
@export var ACTION_HANDLER : StaticActionHandlerStrategy.handlers
@export var PRIMARY_WEAPON : StaticPrimaryWeaponHandler.weapons
@export var MOVEMENT_BONUS_HANDLER : StaticMovementBonusHandler.handlers
@export var POWERUP_HANDLER : StaticPowerupHandler.handlers
