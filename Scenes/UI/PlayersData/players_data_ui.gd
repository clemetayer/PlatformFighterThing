extends HBoxContainer
# Manages the UI for all the players in the game

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----

#---- EXPORTS -----
# @export var EXPORT_NAME := 10.0 # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _player_data_ui_scene := preload("res://Scenes/UI/PlayersData/PlayerData/player_data_ui.tscn")
var _players := {}

#==== ONREADY ====
# @onready var onready_var # Optionnal comment

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
func clean() -> void:
	for child in get_children():
		child.queue_free()

func add_player(player_id: int, config : PlayerConfig, lives : int) -> void:
	var player_data = _player_data_ui_scene.instantiate()
	add_child(player_data)
	player_data.init(config.SPRITE_CUSTOMIZATION, config.MOVEMENT_BONUS_HANDLER, config.POWERUP_HANDLER, lives)
	_players[player_id] = player_data

func update_movement(player_id: int, value) -> void:
	if _players.has(player_id):
		_players[player_id].update_movement(value)
	else:
		Logger.error("player %s does not exist in the UI" % player_id)

func update_powerup(player_id: int, value) -> void:
	if _players.has(player_id):
		_players[player_id].update_powerup(value)
	else:
		Logger.error("player %s does not exist in the UI" % player_id)
