extends MarginContainer
# Handles one item for the player selection menu

##### SIGNALS #####
signal player_added

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# @export var EXPORT_NAME := 10.0 # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

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
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

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
