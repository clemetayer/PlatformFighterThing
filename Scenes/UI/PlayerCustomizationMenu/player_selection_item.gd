extends MarginContainer
# Handles one item for the player selection menu

##### SIGNALS #####
signal player_added

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _current_config: PlayerConfig

#==== ONREADY ====
@onready var onready_paths := {
	"add_player_button": $"AddPlayer",
	"main_menu": $"Main",
	"presets_menu": $"Presets",
	"primary_weapons_menu": $"PrimaryWeaponsGrid",
	"movement_bonus_menu": $"MovementBonusGrid",
	"powerup_menu": $"PowerupGrid"
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
	onready_paths.main_menu.update_player_config(_current_config)


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
func _on_add_player_pressed() -> void:
	emit_signal("player_added")
	onready_paths.add_player_button.hide()
	onready_paths.main_menu.show()

func _on_main_delete_item() -> void:
	onready_paths.main_menu.hide()
	onready_paths.add_player_button.show()

func _on_main_open_movement_bonus_menu_triggered() -> void:
	onready_paths.main_menu.hide()
	onready_paths.movement_bonus_menu.show()

func _on_main_open_powerup_menu_triggered() -> void:
	onready_paths.main_menu.hide()
	onready_paths.powerup_menu.show()

func _on_main_open_preset_menu_triggered() -> void:
	onready_paths.main_menu.hide()
	onready_paths.presets_menu.show()

func _on_main_open_primary_weapon_menu_triggered() -> void:
	onready_paths.main_menu.hide()
	onready_paths.primary_weapons_menu.show()

func _on_presets_close_triggered() -> void:
	onready_paths.presets_menu.hide()
	onready_paths.main_menu.show()

func _on_primary_weapons_grid_close_triggered() -> void:
	onready_paths.primary_weapons_menu.hide()
	onready_paths.main_menu.show()

func _on_movement_bonus_grid_close_triggered() -> void:
	onready_paths.movement_bonus_menu.hide()
	onready_paths.main_menu.show()

func _on_powerup_grid_close_triggered() -> void:
	onready_paths.powerup_menu.hide()
	onready_paths.main_menu.show()

func _on_primary_weapons_grid_item_selected(item: ItemGridMenuElement) -> void:
	_current_config.PRIMARY_WEAPON = item.ITEM_ID as StaticPrimaryWeaponHandler.handlers
	onready_paths.main_menu.update_primary_weapon(item.ITEM_ID)
	onready_paths.primary_weapons_menu.hide()
	onready_paths.main_menu.show()

func _on_movement_bonus_grid_item_selected(item: ItemGridMenuElement) -> void:
	_current_config.MOVEMENT_BONUS_HANDLER = item.ITEM_ID as StaticMovementBonusHandler.handlers
	onready_paths.main_menu.update_movement_bonus(item.ITEM_ID)
	onready_paths.movement_bonus_menu.hide()
	onready_paths.main_menu.show()

func _on_powerup_grid_item_selected(item: ItemGridMenuElement) -> void:
	_current_config.POWERUP_HANDLER = item.ITEM_ID as StaticPowerupHandler.handlers
	onready_paths.main_menu.update_powerup(item.ITEM_ID)
	onready_paths.powerup_menu.hide()
	onready_paths.main_menu.show()

func _on_presets_preset_selected(preset: PlayerConfig) -> void:
	_current_config = preset
	onready_paths.main_menu.update_player_config(preset)
	onready_paths.presets_menu.hide()
	onready_paths.main_menu.show()
