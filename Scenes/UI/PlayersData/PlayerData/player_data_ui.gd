extends Control
# Manages the player data ui

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const TEMP_PLAYER_NAME := "temporary_man"

#---- EXPORTS -----
@export var player_name : RigidBody2D
@export var player_sprites : SpriteCustomizationResource

#---- STANDARD -----
#==== PRIVATE ====
var _lives_ui_load = preload("res://Scenes/UI/PlayersData/PlayerData/LivesDataUIBlock/lives_data_ui_block.tscn")
var _movement_ui
var _powerup_ui
var _lives_ui

#==== ONREADY ====
@onready var onready_paths := {
	"sprites": {
		"root": $"VBoxContainer/Data/CenterContainer/Sprite",
		"body": $"VBoxContainer/Data/CenterContainer/Sprite/Body",
		"outline": $"VBoxContainer/Data/CenterContainer/Sprite/Outline"
	},
	"important_data": $"VBoxContainer/Data/ImportantData",
	"name": $"VBoxContainer/Name"
}

##### PUBLIC METHODS #####
func init(sprites : SpriteCustomizationResource, movement: int, powerup: int, lives : int) -> void:
	_clean()
	_init_sprites(sprites.BODY_COLOR, sprites.OUTLINE_COLOR)
	_init_movement(movement)
	_add_h_separator()
	_init_powerup(powerup)
	_add_h_separator()
	_init_lives(lives)
	_init_name(TEMP_PLAYER_NAME)

func update_movement(value) -> void:
	if is_instance_valid(_movement_ui):
		_movement_ui.set_value(value)

func update_powerup(value) -> void:
	if is_instance_valid(_powerup_ui):
		_powerup_ui.set_value(value)

func update_lives(value : int) -> void:
	if is_instance_valid(_lives_ui):
		_lives_ui.set_value(value)

##### PROTECTED METHODS #####
func _clean() -> void:
	for child in onready_paths.important_data.get_children():
		child.queue_free()

func _add_h_separator() -> void:
	var separator = HSeparator.new()
	onready_paths.important_data.add_child(separator)

func _init_sprites(body : Color, outline : Color) -> void:
	onready_paths.sprites.body.modulate = body
	onready_paths.sprites.outline.modulate = outline

func _init_movement(handler : int) -> void:
	var setting = load(MovementDataUiSettings.data[handler])
	var ui = setting.UI_SCENE.instantiate()
	_movement_ui = ui
	onready_paths.important_data.add_child(ui)
	ui.set_icon(setting.ICON)

func _init_powerup(powerup : int) -> void:
	var setting = load(PowerupDataUISettings.data[powerup])
	var ui = setting.UI_SCENE.instantiate()
	_powerup_ui = ui
	onready_paths.important_data.add_child(ui)
	ui.set_icon(setting.ICON)

func _init_lives(lives : int) -> void:
	var ui = _lives_ui_load.instantiate()
	_lives_ui = ui
	onready_paths.important_data.add_child(ui)
	ui.set_value(lives)

func _init_name(p_name : String) -> void:
	onready_paths.name.text = p_name

##### SIGNAL MANAGEMENT #####
func _on_movement_update_ui(value) -> void:
	if is_instance_valid(_movement_ui):
		_movement_ui.set_value(value)
