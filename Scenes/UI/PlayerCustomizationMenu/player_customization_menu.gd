extends Control
# handles the player customization menu

##### VARIABLES #####
#---- CONSTANTS -----
const GAME_MANAGER_SCENE := "res://Scenes/GameManagers/game_manager.tscn"

#---- STANDARD -----
#==== PRIVATE ====
var _current_config: PlayerConfig

#==== ONREADY ====
@onready var onready_paths := {
	"player_config_display": $"MarginContainer/TabContainer/PlayerConfig/PlayerConfigDisplay",
	"presets": $"MarginContainer/TabContainer/Presets",
	"name": $"MarginContainer/TabContainer/Name",
	"elimination_text": $"MarginContainer/TabContainer/EliminationText",
	"customization": $"MarginContainer/TabContainer/Customization",
	"primary_weapon": $"MarginContainer/TabContainer/PrimaryWeapon",
	"movement_bonus": $"MarginContainer/TabContainer/MovementBonus",
	"powerup": $"MarginContainer/TabContainer/Powerup",
	"save_preset_popup": $"SavePresetPopup"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_load_default_config()
	_init_primary_weapon_items()
	_init_movement_bonus_items()
	_init_powerup_items()


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
	_current_config = load(StaticUtils.DEFAULT_CONFIG_PATH)
	_update_elements_from_config(_current_config)
	
func _update_elements_from_config(config: PlayerConfig) -> void:
	onready_paths.player_config_display.update_player(config)
	onready_paths.customization.update_config(config.SPRITE_CUSTOMIZATION)
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
	onready_paths.player_config_display.update_eyes(load(eyes_image_path))

func _on_customization_mouth_changed(mouth_image_path: String) -> void:
	_current_config.SPRITE_CUSTOMIZATION.MOUTH_TEXTURE_PATH = mouth_image_path
	onready_paths.player_config_display.update_mouth(load(mouth_image_path))

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
	onready_paths.player_config_display.update_powerup(item.ITEM_ID)

func _on_presets_save_preset_triggered() -> void:
	onready_paths.save_preset_popup.set_preset_to_save(_current_config)
	onready_paths.save_preset_popup.show()

func _on_elimination_text_elimination_text_updated(new_text: String) -> void:
	_current_config.ELIMINATION_TEXT = new_text

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(GAME_MANAGER_SCENE)

func _on_customization_eyes_color_changed(eyes_color: Color) -> void:
	_current_config.SPRITE_CUSTOMIZATION.EYES_COLOR = eyes_color
	onready_paths.player_config_display.update_eyes_color(eyes_color)

func _on_customization_mouth_color_changed(mouth_color: Color) -> void:
	_current_config.SPRITE_CUSTOMIZATION.MOUTH_COLOR = mouth_color
	onready_paths.player_config_display.update_mouth_color(mouth_color)

func _on_save_preset_popup_preset_saved() -> void:
	onready_paths.presets.refresh()
