extends VBoxContainer
# handles the sprite section in the player selection menu

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"name": $"Name",
	"player_sprite": $"Player",
	"weapons": {
		"primary": $"Weapons/Primary",
		"powerup": $"Weapons/Powerup",
		"movement_bonus": $"Weapons/MovementBonus"
	}
}

##### PUBLIC METHODS #####
func update_player(player_config: PlayerConfig) -> void:
	update_name(player_config.PLAYER_NAME)
	onready_paths.player_sprite.update_sprite(player_config.SPRITE_CUSTOMIZATION)
	update_primary_weapon(player_config.PRIMARY_WEAPON)
	update_powerup(player_config.POWERUP_HANDLER)
	update_movement_bonus(player_config.MOVEMENT_BONUS_HANDLER)

func update_primary_weapon(weapon: StaticPrimaryWeaponHandler.handlers) -> void:
	onready_paths.weapons.primary.texture = load(StaticPrimaryWeaponHandler.get_icon_path(weapon))

func update_powerup(powerup: StaticPowerupHandler.handlers) -> void:
	onready_paths.weapons.powerup.texture = load(StaticPowerupHandler.get_icon_path(powerup))

func update_movement_bonus(movement_bonus: StaticMovementBonusHandler.handlers) -> void:
	onready_paths.weapons.movement_bonus.texture = load(StaticMovementBonusHandler.get_icon_path(movement_bonus))

func update_name(player_name: String) -> void:
	onready_paths.name.text = player_name

func update_body(color: Color) -> void:
	onready_paths.player_sprite.update_body(color)

func update_outline(color: Color) -> void:
	onready_paths.player_sprite.update_outline(color)

func update_eyes(texture: Texture2D) -> void:
	onready_paths.player_sprite.update_eyes(texture)

func update_eyes_color(color: Color) -> void:
	onready_paths.player_sprite.update_eyes_color(color)

func update_mouth(texture: Texture2D) -> void:
	onready_paths.player_sprite.update_mouth(texture)

func update_mouth_color(color: Color) -> void:
	onready_paths.player_sprite.update_mouth_color(color)