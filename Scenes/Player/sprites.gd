extends Node2D
# script to handle the look of the character

##### VARIABLES #####
#---- EXPORTS -----
@export var SPRITE_CUSTOMIZATION: SpriteCustomizationResource

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"body": $"Body",
	"outline": $"Outline",
	"rotate_elements": $"RotateElements",
	"eyes": $"RotateElements/Eyes",
	"mouth": $"RotateElements/Mouth"
}

##### PUBLIC METHODS #####
func load_sprite_preset(sprite_customization: SpriteCustomizationResource) -> void:
	SPRITE_CUSTOMIZATION = sprite_customization
	onready_paths.body.modulate = SPRITE_CUSTOMIZATION.BODY_COLOR
	onready_paths.outline.modulate = SPRITE_CUSTOMIZATION.OUTLINE_COLOR
	# onready_paths.eyes.texture = load(sprite_customization.EYES_TEXTURE_PATH)
	# onready_paths.mouth.texture = load(sprite_customization.MOUTH_TEXTURE_PATH)

func aim(relative_aim_position: Vector2) -> void:
	var analog_angle = Vector2.ZERO.angle_to_point(relative_aim_position)
	onready_paths.rotate_elements.rotation = analog_angle
	if abs(analog_angle) >= PI / 2.0:
		onready_paths.rotate_elements.scale.y = abs(onready_paths.rotate_elements.scale.y) * -1
	else:
		onready_paths.rotate_elements.scale.y = abs(onready_paths.rotate_elements.scale.y)
