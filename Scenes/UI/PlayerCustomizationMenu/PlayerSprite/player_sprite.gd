extends MarginContainer
# handles the player sprite

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"body": $"Body",
	"outline": $"Outline",
	"eyes": $"Eyes",
	"mouth": $"Mouth"
}

##### PUBLIC METHODS #####
func update_sprite(sprite_config: SpriteCustomizationResource) -> void:
	update_body(sprite_config.BODY_COLOR)
	update_outline(sprite_config.OUTLINE_COLOR)
	update_eyes(load(sprite_config.EYES_TEXTURE_PATH))
	update_mouth(load(sprite_config.MOUTH_TEXTURE_PATH))

func update_body(color: Color) -> void:
	onready_paths.body.modulate = color

func update_outline(color: Color) -> void:
	onready_paths.outline.modulate = color

func update_eyes(texture: Texture2D) -> void:
	onready_paths.eyes.texture = texture

func update_mouth(texture: Texture2D) -> void:
	onready_paths.mouth.texture = texture
