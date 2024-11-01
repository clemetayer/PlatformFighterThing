extends Node2D
# script to handle the look of the character

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
@export var SPRITE_CUSTOMIZATION : SpriteCustomizationResource

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths := {
	"body": $"Body",
	"outline": $"Outline"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
func load_sprite_preset(sprite_customization : SpriteCustomizationResource) -> void:
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		SPRITE_CUSTOMIZATION = sprite_customization
		onready_paths.body.modulate = SPRITE_CUSTOMIZATION.BODY_COLOR
		onready_paths.outline.modulate = SPRITE_CUSTOMIZATION.OUTLINE_COLOR
	
##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
