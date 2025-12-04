extends Control
# handles the player customization menu

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const DEFAULT_CONFIG_PATH := "res://Scenes/Player/PlayerConfigs/default_player_config.tres"

#---- EXPORTS -----
# @export var EXPORT_NAME := 10.0 # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _current_config: PlayerConfig

#==== ONREADY ====
@onready var onready_paths := {
	"player_config_display": $"TabContainer/PlayerConfigDisplay/PlayerConfigDisplay",
	"presets": $"TabContainer/Presets",
	"name": $"TabContainer/Name",
	"elimination_text": $"TabContainer/EliminationText",
	"customization": $"TabContainer/Customization",
	"primary_weapon": $"TabContainer/PrimaryWeapon",
	"movement_bonus": $"TabContainer/MovementBonus",
	"powerup": $"TabContainer/Powerup",
	"save_preset_popup": $"SavePresetPopup"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_default_config()
	_init_primary_weapon_items()
	_init_movement_bonus_items()
	_init_powerup_items()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _init_primary_weapon_items() -> void:
	onready_paths.primary_weapon.set_items(
		StaticItemDescriptions.get_primary_weapons_descriptions()
	)

func _init_movement_bonus_items() -> void:
	onready_paths.movement_bonus.set_items(
		StaticItemDescriptions.get_movement_bonus_descriptions()
	)

func _init_powerup_items() -> void:
	onready_paths.powerup.set_items(
		StaticItemDescriptions.get_powerups_descriptions()
	)

func _load_default_config() -> void:
	_current_config = load(DEFAULT_CONFIG_PATH)
	_update_elements_from_config(_current_config)
	
func _update_elements_from_config(config: PlayerConfig) -> void:
	onready_paths.player_config_display.update_player(config)
	onready_paths.customization.update_config(config)
	onready_paths.name.update_player_name(config.PLAYER_NAME)
	onready_paths.elimination_text.set_elimination_text(config.ELIMINATION_TEXT)

##### SIGNAL MANAGEMENT #####
func _on_presets_preset_selected(preset: PlayerConfig) -> void:
	_current_config = preset
	_update_elements_from_config(preset)

func _on_name_name_selected(p_name: String) -> void:
	_current_config.PLAYER_NAME = p_name
	onready_paths.player_config_display.update_name(p_name)

func _on_customization_body_color_changed(new_color: Color) -> void:
	_current_config.SPRITE_CUSTOMIZATION.BODY_COLOR = new_color
	onready_paths.player_config_display.update_body(new_color)

func _on_customization_eyes_changed(eyes_image_path: String) -> void:
	_current_config.SPRITE_CUSTOMIZATION.EYES_TEXTURE_PATH = eyes_image_path
	onready_paths.player_config_display.update_eyes(eyes_image_path)

func _on_customization_mouth_changed(mouth_image_path: String) -> void:
	_current_config.SPRITE_CUSTOMIZATION.MOUTH_TEXTURE_PATH = mouth_image_path
	onready_paths.player_config_display.update_mouth(mouth_image_path)

func _on_customization_outline_color_changed(new_color: Color) -> void:
	_current_config.SPRITE_CUSTOMIZATION.OUTLINE_COLOR = new_color
	onready_paths.player_config_display.update_outline(new_color)

func _on_primary_weapon_item_selected(item: ItemGridMenuElement) -> void:
	_current_config.PRIMARY_WEAPON = item.ITEM_ID as StaticPrimaryWeaponHandler.handlers
	onready_paths.player_config_display.update_primary_weapon(item.ITEM_ID)

func _on_movement_bonus_item_selected(item: ItemGridMenuElement) -> void:
	_current_config.MOVEMENT_BONUS_HANDLER = item.ITEM_ID as StaticMovementBonusHandler.handlers
	onready_paths.player_config_display.update_movement_bonus(item.ITEM_ID)

func _on_powerup_item_selected(item: ItemGridMenuElement) -> void:
	_current_config.POWERUP_HANDLER = item.ITEM_ID as StaticPowerupHandler.handlers
	onready_paths.player_config_display.powerup(item.ITEM_ID)

func _on_presets_save_preset_triggered() -> void:
	onready_paths.save_preset_popup.set_preset_to_save(_current_config)
	onready_paths.save_preset_popup.show()

func _on_elimination_text_elimination_text_updated(new_text: String) -> void:
	_current_config.ELIMINATION_TEXT = new_text
