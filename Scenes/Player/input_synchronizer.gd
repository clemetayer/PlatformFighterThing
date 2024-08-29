extends MultiplayerSynchronizer
# Input synchronizer

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----

#---- EXPORTS -----

#---- STANDARD -----
#==== PUBLIC ====
@export var action_states : Dictionary

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths := {
	"action_handler":null
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	# Only process for the local player.
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if is_instance_valid(onready_paths.action_handler):
		action_states = onready_paths.action_handler._action_states

##### PUBLIC METHODS #####
func set_action_handler(handler : StaticActionHandlerStrategy.handlers) -> void:
	onready_paths.action_handler = StaticActionHandlerStrategy.get_handler(handler)
	add_child(onready_paths.action_handler)

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
