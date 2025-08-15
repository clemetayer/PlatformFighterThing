extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- CONSTANTS -----
# const CONST := "value"

#---- VARIABLES -----
var action_manager
var action_handler
var use_called_times_called := 0

##### SETUP #####
func before_each():
	action_manager = partial_double(load("res://Scenes/Player/action_manager.gd")).new()
	action_handler = load("res://Scenes/ActionHandlers/action_handler_base.gd").new()
	action_manager._action_handler_base = action_handler
	use_called_times_called = 0

##### TEARDOWN #####
func after_each():
	action_handler.free()

##### TESTS #####
func test_handle_actions():
	# given
	stub(action_manager,"_handle_direction").to_do_nothing()
	stub(action_manager,"_handle_aim").to_do_nothing()
	stub(action_manager,"_handle_jump").to_do_nothing()
	stub(action_manager,"_handle_fire").to_do_nothing()
	stub(action_manager,"_handle_movement_bonus").to_do_nothing()
	stub(action_manager,"_handle_parry").to_do_nothing()
	stub(action_manager,"_handle_powerup").to_do_nothing()
	# when
	action_manager._handle_actions()
	# then
	assert_called(action_manager, "_handle_direction")
	assert_called(action_manager, "_handle_aim")
	assert_called(action_manager, "_handle_jump")
	assert_called(action_manager, "_handle_fire")
	assert_called(action_manager, "_handle_movement_bonus")
	assert_called(action_manager, "_handle_parry")
	assert_called(action_manager, "_handle_powerup")

var handle_direction_params := [
	[ActionHandlerBase.actions.LEFT, Vector2(-1,0)],
	[ActionHandlerBase.actions.RIGHT, Vector2(1,0)],
	[ActionHandlerBase.actions.UP, Vector2(0,-1)],
	[ActionHandlerBase.actions.DOWN, Vector2(0,1)]
]
func test_handle_direction(params = use_parameters(handle_direction_params)):
	# given
	stub(action_manager, "_is_action_active").to_return(false)
	stub(action_manager, "_is_action_active").when_passed(params[0]).to_return(true)
	var player_root = load("res://Scenes/Player/player.gd").new()
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	onready_paths_node.player_root = player_root
	action_manager.onready_paths_node = onready_paths_node
	# when
	action_manager._handle_direction()
	# then
	assert_eq(player_root.direction, params[1])
	# cleanup
	player_root.free()
	onready_paths_node.free()
	
func test_handle_aim():
	# given
	var primary_weapon = double(load("res://Scenes/Weapons/Primary/primary_weapon_base.gd")).new()
	stub(primary_weapon, "aim").to_do_nothing()
	var crosshair = load("res://Scenes/Weapons/Primary/crosshair.gd").new()
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	onready_paths_node.crosshair = crosshair
	onready_paths_node.primary_weapon = primary_weapon
	action_manager.onready_paths_node = onready_paths_node
	stub(action_manager, "_get_relative_aim_position").to_return(Vector2.RIGHT)
	# when
	action_manager._handle_aim()
	# then
	assert_called(primary_weapon, "aim", [Vector2.RIGHT])
	assert_eq(crosshair.position, Vector2.RIGHT)
	# cleanup
	crosshair.free()
	onready_paths_node.free()

var handle_jump_params := [
	[true],
	[false]
]
func test_handle_jump(params = use_parameters(handle_jump_params)):
	# given
	var player_root = load("res://Scenes/Player/player.gd").new()
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	onready_paths_node.player_root = player_root
	action_manager.onready_paths_node = onready_paths_node
	stub(action_manager, "_is_action_active").to_return(params[0])
	# when
	action_manager._handle_jump()
	# then
	assert_eq(player_root.jump_triggered,params[0])
	# cleanup
	player_root.free()
	onready_paths_node.free()

var handle_fire_params := [
	[true],
	[false]
]
func test_handle_fire(params = use_parameters(handle_fire_params)):
	# given
	stub(action_manager, "_is_action_active").to_return(params[0])
	var primary_weapon = double(load("res://Scenes/Weapons/Primary/primary_weapon_base.gd")).new()
	stub(primary_weapon, "fire").to_do_nothing()
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	onready_paths_node.primary_weapon = primary_weapon
	action_manager.onready_paths_node = onready_paths_node
	# when
	action_manager._handle_fire()
	# then
	if params[0]:
		assert_called(primary_weapon, "fire")
	else:
		assert_not_called(primary_weapon, "fire")
	# cleanup
	onready_paths_node.free()

var handle_movement_params := [
	[true],
	[false]
]
func test_handle_movement_bonus(params = use_parameters(handle_movement_params)):
	# given
	stub(action_manager, "_is_action_just_active").to_return(params[0])
	var movement_bonus = double(load("res://Scenes/Movement/movement_bonus_base.gd")).new()
	stub(movement_bonus, "activate").to_do_nothing()
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	onready_paths_node.movement_bonus = movement_bonus
	action_manager.onready_paths_node = onready_paths_node
	# when
	action_manager._handle_movement_bonus()
	# then
	if params[0]:
		assert_called(movement_bonus, "activate")
	else:
		assert_not_called(movement_bonus, "activate")
	# cleanup
	onready_paths_node.free()

var handle_parry_params := [
	[true],
	[false]
]
func test_handle_parry(params = use_parameters(handle_parry_params)):
	# given
	stub(action_manager, "_is_action_just_active").to_return(params[0])
	var parry = double(load("res://Scenes/Player/parry.gd")).new()
	stub(parry, "parry").to_do_nothing()
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	onready_paths_node.parry_area = parry
	action_manager.onready_paths_node = onready_paths_node
	# when
	action_manager._handle_parry()
	# then
	if params[0]:
		assert_called(parry, "parry")
	else:
		assert_not_called(parry, "parry")
	# cleanup
	onready_paths_node.free()

var handle_powerup_params := [
	[true, false, false],
	[false, true, false],
	[true, true, true]
]
func test_handle_powerup(params = use_parameters(handle_powerup_params)):
	# given
	stub(action_manager, "_is_action_just_active").to_return(params[0])
	var runtime_utils = double(load("res://Utils/runtime_utils.gd")).new()
	stub(runtime_utils, "is_authority").to_return(params[1])
	action_manager._runtime_utils = runtime_utils
	var powerup_manager = load("res://test/unit/Player/test_action_manager_mocks/mock_powerup_manager.gd").new()
	add_child(powerup_manager)
	wait_for_signal(powerup_manager.tree_entered, 0.25)
	powerup_manager.connect("use_called",_on_use_called)
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	onready_paths_node.powerup_manager = powerup_manager
	action_manager.onready_paths_node = onready_paths_node
	# when
	action_manager._handle_powerup()
	# then
	assert_eq(use_called_times_called, 1 if params[2] else 0)
	# cleanup
	powerup_manager.free()
	onready_paths_node.free()

var is_action_active_params = [
	[true],
	[false]
]
func test_is_action_active(params = use_parameters(is_action_active_params)):
	# given
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	var input_synchronizer = load("res://Scenes/Player/input_synchronizer.gd").new()
	var action_states = {
		ActionHandlerBase.actions.JUMP: ActionHandlerBase.states.ACTIVE if params[0] else ActionHandlerBase.states.INACTIVE
	}
	input_synchronizer.action_states = action_states
	onready_paths_node.input_synchronizer = input_synchronizer
	action_manager.onready_paths_node = onready_paths_node
	# when
	var res = action_manager._is_action_active(ActionHandlerBase.actions.JUMP)
	# then
	assert_eq(res,params[0])
	# cleanup
	input_synchronizer.free()
	onready_paths_node.free()

var is_action_just_active_params = [
	[true],
	[false]
]
func test_is_action_just_active(params = use_parameters(is_action_just_active_params)):
	# given
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	var input_synchronizer = load("res://Scenes/Player/input_synchronizer.gd").new()
	var action_states = {
		ActionHandlerBase.actions.JUMP: ActionHandlerBase.states.JUST_ACTIVE if params[0] else ActionHandlerBase.states.INACTIVE
	}
	input_synchronizer.action_states = action_states
	onready_paths_node.input_synchronizer = input_synchronizer
	action_manager.onready_paths_node = onready_paths_node
	# when
	var res = action_manager._is_action_active(ActionHandlerBase.actions.JUMP)
	# then
	assert_eq(res,params[0])
	# cleanup
	input_synchronizer.free()
	onready_paths_node.free()

func test_get_relative_aim_position():
	# given
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	var input_synchronizer = load("res://Scenes/Player/input_synchronizer.gd").new()
	input_synchronizer.relative_aim_position = Vector2.UP
	onready_paths_node.input_synchronizer = input_synchronizer
	action_manager.onready_paths_node = onready_paths_node
	# when
	var res = action_manager._get_relative_aim_position()
	# then
	assert_eq(res, Vector2.UP)
	# cleanup
	input_synchronizer.free()
	onready_paths_node.free()

var on_SceneUtils_toggle_scene_freeze_params := [
	[true],
	[false]
]
func test_on_SceneUtils_toggle_scene_freeze(params = use_parameters(on_SceneUtils_toggle_scene_freeze_params)):
	# given
	# when
	action_manager._on_SceneUtils_toggle_scene_freeze(params[0])
	# then
	assert_eq(action_manager._frozen, params[0])

##### UTILS #####
func _on_use_called() -> void:
	use_called_times_called += 1