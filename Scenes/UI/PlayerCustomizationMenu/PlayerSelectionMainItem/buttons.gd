extends VBoxContainer
# handles the buttons in the player selection menu

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"primary_weapon": $"PrimaryWeapon",
	"movement_bonus": $"MovementBonus",
	"powerup": $"Powerup"
}

##### PUBLIC METHODS #####
func set_primary_weapon_icon(weapon: StaticPrimaryWeaponHandler.handlers) -> void:
	onready_paths.primary_weapon.icon = load(StaticPrimaryWeaponHandler.get_icon_path(weapon))

func set_movement_bonus_icon(movement_bonus: StaticMovementBonusHandler.handlers) -> void:
	onready_paths.movement_bonus.icon = load(StaticMovementBonusHandler.get_icon_path(movement_bonus))

func set_powerup_icon(powerup: StaticPowerupHandler.handlers) -> void:
	onready_paths.powerup.icon = load(StaticPowerupHandler.get_icon_path(powerup))
