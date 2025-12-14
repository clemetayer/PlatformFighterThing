extends Control
# handles the player selection menu, but for the online mode

##### SIGNALS #####
signal player_ready(config: PlayerConfig)

##### VARIABLES #####
#---- CONSTANTS -----
const ACTION_HANDLER := StaticActionHandler.handlers.INPUT

#---- STANDARD -----
#==== PRIVATE ====
var _current_config: PlayerConfig

#==== ONREADY ====
@onready var onready_paths := {
	"menu_root": $"MenuRoot",
	"waiting_players_label": $"WaitingForOtherPlayersText",
	"main_menu": $"MenuRoot/TabContainer/PlayerConfig",
	"primary_weapons_menu": $"MenuRoot/TabContainer/PrimaryWeapon",
	"movement_bonus_menu": $"MenuRoot/TabContainer/MovementBonus",
	"powerup_menu": $"MenuRoot/TabContainer/Powerup"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_default_config()
	_init_primary_weapon_items()
	_init_movement_bonus_items()
	_init_powerup_items()

##### PROTECTED METHODS #####
func _init_default_config() -> void:
	_current_config = load(StaticUtils.DEFAULT_CONFIG_PATH)
	onready_paths.main_menu.update_player(_current_config)

func _init_primary_weapon_items() -> void:
	onready_paths.primary_weapons_menu.set_items(
		StaticItemDescriptions.get_primary_weapons_descriptions()
	)

func _init_movement_bonus_items() -> void:
	onready_paths.movement_bonus_menu.set_items(
		StaticItemDescriptions.get_movement_bonus_descriptions()
	)

func _init_powerup_items() -> void:
	onready_paths.powerup_menu.set_items(
		StaticItemDescriptions.get_powerups_descriptions()
	)

##### SIGNAL MANAGEMENT #####
func _on_ready_button_pressed() -> void:
	emit_signal("player_ready", _current_config)
	onready_paths.menu_root.hide()
	onready_paths.waiting_players_label.show()

func _on_presets_preset_selected(preset: PlayerConfig) -> void:
	_current_config = preset
	onready_paths.main_menu.update_player(_current_config)

func _on_primary_weapon_item_selected(item: ItemGridMenuElement) -> void:
	_current_config.PRIMARY_WEAPON = item.ITEM_ID as StaticPrimaryWeaponHandler.handlers
	onready_paths.main_menu.update_primary_weapon(item.ITEM_ID)

func _on_movement_bonus_item_selected(item: ItemGridMenuElement) -> void:
	_current_config.MOVEMENT_BONUS_HANDLER = item.ITEM_ID as StaticMovementBonusHandler.handlers
	onready_paths.main_menu.update_movement_bonus(item.ITEM_ID)

func _on_powerup_item_selected(item: ItemGridMenuElement) -> void:
	_current_config.POWERUP_HANDLER = item.ITEM_ID as StaticPowerupHandler.handlers
	onready_paths.main_menu.update_powerup(item.ITEM_ID)
