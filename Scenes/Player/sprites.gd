extends Node2D
# script to handle the look of the character

##### VARIABLES #####
#---- EXPORTS -----
@export var SPRITE_CUSTOMIZATION : SpriteCustomizationResource

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"body": $"Body",
	"outline": $"Outline"
}

##### PUBLIC METHODS #####
func load_sprite_preset(sprite_customization : SpriteCustomizationResource) -> void:
	SPRITE_CUSTOMIZATION = sprite_customization
	onready_paths.body.modulate = SPRITE_CUSTOMIZATION.BODY_COLOR
	onready_paths.outline.modulate = SPRITE_CUSTOMIZATION.OUTLINE_COLOR
