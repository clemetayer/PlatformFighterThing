extends ActionHandlerBase

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _current_target: Node2D
var _player: Node2D

#==== ONREADY ====
@onready var onready_hold_fire_key_timer: Timer = $"HoldFireKeyTime"


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_select_random_player_target()


##### PUBLIC METHODS #####
func set_player(player: Node2D) -> void:
	_player = player


func get_target() -> Node2D:
	DebugInterface.set_debug_text("target", _current_target)
	return _current_target


func get_player() -> Node2D:
	DebugInterface.set_debug_text("player", _player)
	return _player


func get_relative_aim_position() -> Vector2:
	return relative_aim_position


func set_jump(enabled: bool) -> void:
	_action_states[actions.JUMP] = states.ACTIVE if enabled else states.INACTIVE


# -1 = left, 0 = stay, 1 = right
func set_movement_direction(direction: int) -> void:
	match direction:
		-1:
			_action_states[actions.LEFT] = states.ACTIVE
			_action_states[actions.RIGHT] = states.INACTIVE
		1:
			_action_states[actions.LEFT] = states.INACTIVE
			_action_states[actions.RIGHT] = states.ACTIVE
		_:
			_action_states[actions.LEFT] = states.INACTIVE
			_action_states[actions.RIGHT] = states.INACTIVE


func set_relative_aim_position(p_position: Vector2) -> void:
	relative_aim_position = p_position
	onready_hold_fire_key_timer.stop()
	onready_hold_fire_key_timer.start()


func fire() -> void:
	_action_states[actions.FIRE] = states.ACTIVE


##### PROTECTED METHODS #####
func _select_random_player_target() -> void:
	var players = get_tree().get_nodes_in_group(GroupUtils.PLAYER_GROUP_NAME)
	players.erase(_player)
	_current_target = players.pick_random()


##### SIGNAL MANAGEMENT #####
func _on_change_target_timer_timeout() -> void:
	_select_random_player_target()


func _on_hold_fire_key_time_timeout() -> void:
	_action_states[actions.FIRE] = states.INACTIVE
