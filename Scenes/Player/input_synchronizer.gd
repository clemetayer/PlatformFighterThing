extends Node

# Input synchronizer

##### VARIABLES #####
#---- STANDARD -----
#==== PUBLIC ====
@export var action_states: Dictionary
@export var relative_aim_position := Vector2.ZERO

#==== ONREADY ====
@onready var onready_paths_node := $"../Paths"


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if is_instance_valid(onready_paths_node.action_handler):
		action_states = onready_paths_node.action_handler._action_states
		relative_aim_position = onready_paths_node.action_handler.relative_aim_position


##### PUBLIC METHODS #####
func set_action_handler(handler: StaticActionHandler.handlers) -> void:
	onready_paths_node.action_handler = StaticActionHandler.get_handler(handler)
	onready_paths_node.action_handler.name = "ActionHandler"
	onready_paths_node.action_handler.set_player(onready_paths_node.player_root)
	onready_paths_node.player_root.add_child(onready_paths_node.action_handler)
