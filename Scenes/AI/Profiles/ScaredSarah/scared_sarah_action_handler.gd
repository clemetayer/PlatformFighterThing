extends ActionHandlerBase

# AI Action handler for a player that tends to run away

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _player: Node2D
var _desired_position: Vector2
var _current_target: Node2D

#==== ONREADY ====
@onready var onready_paths := {
	"hold_fire_key_timer": $"HoldFireKeyTime",
	"search_target_timer": $"SearchTargetTimer",
}


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_select_random_player_target()


##### PUBLIC METHODS #####
func set_player(player: Node2D) -> void:
	_player = player


func get_player() -> Node2D:
	return _player


func get_target() -> Node2D:
	return _current_target


func get_relative_aim_position() -> Vector2:
	return relative_aim_position


func set_relative_aim_position(p_position: Vector2) -> void:
	relative_aim_position = p_position


func get_opponents_positions() -> Array:
	var players = get_tree().get_nodes_in_group(GroupUtils.PLAYER_GROUP_NAME)
	players.erase(_player)
	return players.map(func(player): return player.get_global_position())


# returns [min_global_pos, max_global_pos]
func get_level_bounds() -> Array:
	var level_bounds = get_tree().get_nodes_in_group(GroupUtils.LEVEL_BOUNDS_GROUP_NAME)
	return level_bounds[0].get_bounds()


func set_desired_position(desired_position: Vector2) -> void:
	DebugInterface.set_debug_position("scared_sarah_desired_pos", desired_position, Color.GREEN)
	_desired_position = desired_position


func get_desired_position() -> Vector2:
	return _desired_position


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


func trigger_movement_bonus() -> void:
	_action_states[actions.MOVEMENT_BONUS] = states.JUST_ACTIVE
	await get_tree().physics_frame
	_action_states[actions.MOVEMENT_BONUS] = states.INACTIVE


func trigger_parry() -> void:
	_action_states[actions.PARRY] = states.JUST_ACTIVE
	await get_tree().physics_frame
	_action_states[actions.PARRY] = states.INACTIVE


func get_projectiles() -> Array:
	return get_tree().get_nodes_in_group(GroupUtils.PROJECTILE_GROUP_NAME)


func fire() -> void:
	_action_states[actions.FIRE] = states.ACTIVE
	onready_paths.hold_fire_key_timer.stop()
	onready_paths.hold_fire_key_timer.start()


##### PROTECTED METHODS #####
func _select_random_player_target() -> void:
	if is_instance_valid(_current_target):
		_current_target.disconnect("tree_exited", _on_current_target_tree_exited)
	var players = get_tree().get_nodes_in_group(GroupUtils.PLAYER_GROUP_NAME)
	players.erase(_player)
	_current_target = players.pick_random()
	if is_instance_valid(_current_target):
		_current_target.connect("tree_exited", _on_current_target_tree_exited)


##### SIGNAL MANAGEMENT #####
func _on_change_target_timer_timeout() -> void:
	_select_random_player_target()


func _on_current_target_tree_exited() -> void:
	onready_paths.search_target_timer.start()


func _on_search_target_timer_timeout() -> void:
	_select_random_player_target()
	if not is_instance_valid(_current_target):
		onready_paths.search_target_timer.start()


func _on_hold_fire_key_time_timeout() -> void:
	_action_states[actions.FIRE] = states.INACTIVE
