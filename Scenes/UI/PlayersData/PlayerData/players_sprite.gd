extends Control
# Sets the player sprite

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"body": $"Body",
	"outline": $"Outline"
}

##### PUBLIC METHODS #####
func set_sprites(sprites_data : SpriteCustomizationResource) -> void:
	if sprites_data != null:
		onready_paths.body.modulate = sprites_data.BODY_COLOR
		onready_paths.outline.modulate = sprites_data.OUTLINE_COLOR
