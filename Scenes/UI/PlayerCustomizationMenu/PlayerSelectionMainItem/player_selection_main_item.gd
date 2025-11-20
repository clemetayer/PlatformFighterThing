extends HBoxContainer
# Handles the main menu of an item in the player selection screen

##### SIGNALS #####
signal open_preset_menu_triggered
signal open_primary_weapon_menu_triggered
signal open_movement_bonus_menu_triggered
signal open_powerup_menu_triggered
signal delete

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"sprite": $"Sprite",
	"buttons": $"Buttons"
}

##### PUBLIC METHODS #####
func update_player_config(config: PlayerConfig) -> void:
	onready_paths.sprite.update_player(config)
	onready_paths.buttons.set_primary_weapon_icon(config.PRIMARY_WEAPON)
	onready_paths.buttons.set_movement_bonus_icon(config.MOVEMENT_BONUS_HANDLER)
	onready_paths.buttons.set_powerup_icon(config.POWERUP_HANDLER)

func update_primary_weapon(weapon: StaticPrimaryWeaponHandler.handlers) -> void:
	onready_paths.sprite.update_primary_weapon(weapon)
	onready_paths.buttons.set_primary_weapon_icon(weapon)

func update_movement_bonus(movement_bonus: StaticMovementBonusHandler.handlers) -> void:
	onready_paths.sprite.update_movement_bonus(movement_bonus)
	onready_paths.buttons.set_movement_bonus_icon(movement_bonus)

func update_powerup(powerup: StaticPowerupHandler.handlers) -> void:
	onready_paths.sprite.update_powerup(powerup)
	onready_paths.buttons.set_powerup_icon(powerup)

##### SIGNAL MANAGEMENT #####
func _on_preset_pressed() -> void:
	emit_signal("open_preset_menu_triggered")

func _on_primary_weapon_pressed() -> void:
	emit_signal("open_primary_weapon_menu_triggered")

func _on_movement_bonus_pressed() -> void:
	emit_signal("open_movement_bonus_menu_triggered")

func _on_powerup_pressed() -> void:
	emit_signal("open_powerup_menu_triggered")

func _on_player_type_pressed() -> void:
	pass # TODO : change player type (Bot, local - keyboard, local - controller 1, online - self, online - opponent, etc.)

func _on_delete_player_pressed() -> void:
	emit_signal("delete")
