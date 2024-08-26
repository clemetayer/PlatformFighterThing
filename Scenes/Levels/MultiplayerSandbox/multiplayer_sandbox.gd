extends Node
# class_name Class
# Sandbox, but in multiplayer

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const SANDBOX_LEVEL_PATH := "res://Scenes/Levels/MultiplayerSandbox/multiplayer_sandbox_level.tscn"

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths := {
	"level":$"Level"
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
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
# Call this function deferred and only on the main authority (server).
func _change_level(scene: PackedScene):
	# Remove old level if any.
	var level = onready_paths.level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Add new level.
	level.add_child(scene.instantiate())

##### SIGNAL MANAGEMENT #####
func _on_p_2p_multiplayer_menu_start_multiplayer_game():
	# Only change level on the server.
	# Clients will instantiate the level via the spawner.
	if multiplayer.is_server():
		_change_level.call_deferred(load(SANDBOX_LEVEL_PATH))
