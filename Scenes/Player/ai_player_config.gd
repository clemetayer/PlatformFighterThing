extends PlayerConfig

class_name AIPlayerConfig

@export var LEVEL: int = 1


func serialize() -> Dictionary:
	return {
		"player_name": PLAYER_NAME,
		"description": DESCRIPTION,
		"action_handler": ACTION_HANDLER,
		"primary_weapon": PRIMARY_WEAPON,
		"movement_bonus_handler": MOVEMENT_BONUS_HANDLER,
		"powerup_handler": POWERUP_HANDLER,
		"sprite_customization": SPRITE_CUSTOMIZATION.serialize(),
		"elimination_text": ELIMINATION_TEXT,
		"level": LEVEL,
	}


func deserialize(data: Dictionary) -> void:
	super(data)
	LEVEL = data.level
