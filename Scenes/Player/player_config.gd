extends Resource
class_name PlayerConfig
# Parameters to give to the player to fine tune it easily

##### VARIABLES #####
#---- EXPORTS -----
@export var ACTION_HANDLER : StaticActionHandlerStrategy.handlers
@export var PRIMARY_WEAPON : StaticPrimaryWeaponHandler.weapons
@export var MOVEMENT_BONUS_HANDLER : StaticMovementBonusHandler.handlers
@export var POWERUP_HANDLER : StaticPowerupHandler.handlers
@export var SPRITE_CUSTOMIZATION : SpriteCustomizationResource
@export var ELIMINATION_TEXT : String

##### PUBLIC METHODS #####
func serialize() -> Dictionary:
    return {
        "action_handler":ACTION_HANDLER,
        "primary_weapon":PRIMARY_WEAPON,
        "movement_bonus_handler":MOVEMENT_BONUS_HANDLER,
        "powerup_handler":POWERUP_HANDLER,
        "sprite_customization":SPRITE_CUSTOMIZATION.serialize(),
        "elimination_text":ELIMINATION_TEXT
    }

func deserialize(data : Dictionary) -> void:
    StaticUtils.map_if_exists(data,"action_handler",self,"ACTION_HANDLER")
    StaticUtils.map_if_exists(data,"primary_weapon",self,"PRIMARY_WEAPON")
    StaticUtils.map_if_exists(data,"movement_bonus_handler",self,"MOVEMENT_BONUS_HANDLER")
    StaticUtils.map_if_exists(data,"powerup_handler",self,"POWERUP_HANDLER")
    if "sprite_customization" in data:
        SPRITE_CUSTOMIZATION = SpriteCustomizationResource.new()
        SPRITE_CUSTOMIZATION.deserialize(data["sprite_customization"])
    StaticUtils.map_if_exists(data,"elimination_text",self,"ELIMINATION_TEXT")