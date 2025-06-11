extends MultiplayerSynchronizer
# Input synchronizer

##### VARIABLES #####
#---- STANDARD -----
#==== PUBLIC ====
@export var action_states : Dictionary
@export var relative_aim_position := Vector2.ZERO

#==== ONREADY ====
@onready var onready_paths_node := $"../Paths"

##### PROCESSING #####
func _ready():
	# Start the process at false by default, to wait for everything to be initialized to detect if one should process inputs or not
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if is_instance_valid(onready_paths_node.action_handler):
		action_states = onready_paths_node.action_handler._action_states
		relative_aim_position = onready_paths_node.action_handler.relative_aim_position

##### PUBLIC METHODS #####
func start_input_detection() -> void:
	set_process(
		RuntimeUtils.is_own_id(onready_paths_node.player_root.id)
		or RuntimeUtils.is_offline_game
	)

func set_action_handler(handler : StaticActionHandlerStrategy.handlers) -> void:
	onready_paths_node.action_handler = StaticActionHandlerStrategy.get_handler(handler)
	onready_paths_node.action_handler.name = "ActionHandler"
	onready_paths_node.player_root.add_child(onready_paths_node.action_handler)
