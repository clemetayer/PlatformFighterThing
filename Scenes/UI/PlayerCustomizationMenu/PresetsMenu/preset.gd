extends Button
# Handles a preset

##### VARIABLES #####
#---- CONSTANTS -----
const HEIGHT_SMALL := 32
const HEIGHT_BIG := 64

#---- EXPORTS -----
@export var SMALL := false

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"name_label": $"Elements/Name",
	"primary_weapon": $"Elements/PrimaryWeapon",
	"movement_bonus": $"Elements/MovementBonus",
	"powerup": $"Elements/Powerup",
	"sprite": {
		"body": $"Elements/Sprite/Body",
		"eyes": $"Elements/Sprite/Eyes",
		"mouth": $"Elements/Sprite/Mouth",
		"outline": $"Elements/Sprite/Outline"
	}
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_preset_size()

##### PUBLIC METHODS #####
func set_preset(preset: PlayerConfig) -> void:
	onready_paths.name_label.text = preset.PLAYER_NAME
	onready_paths.primary_weapon.texture = load(StaticPrimaryWeaponHandler.get_icon_path(preset.PRIMARY_WEAPON))
	onready_paths.movement_bonus.texture = load(StaticMovementBonusHandler.get_icon_path(preset.MOVEMENT_BONUS_HANDLER))
	onready_paths.powerup.texture = load(StaticPowerupHandler.get_icon_path(preset.POWERUP_HANDLER))
	onready_paths.sprite.body.modulate = preset.SPRITE_CUSTOMIZATION.BODY_COLOR
	onready_paths.sprite.outline.modulate = preset.SPRITE_CUSTOMIZATION.OUTLINE_COLOR
	onready_paths.sprite.eyes.texture = load(preset.SPRITE_CUSTOMIZATION.EYES_TEXTURE_PATH)
	onready_paths.sprite.eyes.modulate = preset.SPRITE_CUSTOMIZATION.EYES_COLOR
	onready_paths.sprite.mouth.texture = load(preset.SPRITE_CUSTOMIZATION.MOUTH_TEXTURE_PATH)
	onready_paths.sprite.mouth.modulate = preset.SPRITE_CUSTOMIZATION.MOUTH_COLOR

##### PROTECTED METHODS #####
func _set_preset_size() -> void:
	custom_minimum_size.y = HEIGHT_SMALL if SMALL else HEIGHT_BIG
