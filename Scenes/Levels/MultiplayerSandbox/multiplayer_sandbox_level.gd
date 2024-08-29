extends Node2D
# Multiplayer sandbox level

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYER_SCENE_PATH := "res://Scenes/Player/player.tscn"

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths := {
	"camera": $"Camera2D",
	"players": $"Players"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players.
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)


# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
func add_player(id: int):
	var character = preload(PLAYER_SCENE_PATH).instantiate()
	# Set player id.
	character.player = id
	character.name = str(id)
	# Set action handler
	character.ACTION_HANDLER = StaticActionHandlerStrategy.handlers.INPUT
	character.MOVEMENT_BONUS_HANDLER = StaticMovementBonusHandler.handlers.DASH
	character.POWERUP_HANDLER = StaticPowerupHandler.handlers.SPLITTER
	character.PRIMARY_WEAPON = StaticPrimaryWeaponHandler.weapons.REVOLVER
	onready_paths.players.add_child(character, true)
	onready_paths.camera.PLAYERS.append(onready_paths.camera.get_path_to(character))


func del_player(id: int):
	if not onready_paths.players.has_node(str(id)):
		return
	onready_paths.players.get_node(str(id)).queue_free()

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
