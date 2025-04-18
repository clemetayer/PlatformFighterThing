extends Control
# Manages the player data ui

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- EXPORTS -----
@export var player_name : RigidBody2D
@export var player_sprites : SpriteCustomizationResource

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"sprites": $"VBoxContainer/Data/CenterContainer/Sprite",
	"movement": $"VBoxContainer/Data/ImportantData/Movement",
	"powerup": $"VBoxContainer/Data/ImportantData/Powerup",
	"lives": $"VBoxContainer/Data/ImportantData/Lives",
	"name": $"VBoxContainer/Name"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.sprites.set_sprites(player_sprites)
	onready_paths.name = player_name

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
