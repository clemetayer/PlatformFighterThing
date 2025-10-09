extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- CONSTANTS -----
const PLAYER_1_DEFAULT_CONFIG_PATH := "res://test/integration/GameIntro/player_1.tres"
const PLAYER_2_DEFAULT_CONFIG_PATH := "res://test/integration/GameIntro/player_2.tres"
const DEFAULT_LEVEL_CONFIG_PATH := "res://test/integration/GameIntro/level_default.tres"


#---- VARIABLES -----
var scene
var _sender = InputSender.new(Input)
var default_level 
var player_1_config
var player_2_config

##### SETUP #####
func before_each():
	scene = load("res://test/integration/GameIntro/scene_game_intro.tscn").instantiate()
	add_child_autofree(scene)
	await wait_process_frames(5)

##### TEARDOWN #####
func after_each():
	_sender.release_all()
	_sender.clear()

##### TESTS #####
func test_intro():
	# given
	default_level = load(DEFAULT_LEVEL_CONFIG_PATH)
	player_1_config = load(PLAYER_1_DEFAULT_CONFIG_PATH)
	player_2_config = load(PLAYER_2_DEFAULT_CONFIG_PATH)
	scene.set_level_data(default_level)
	scene.set_player_data(1,player_1_config)
	scene.set_player_data(2,player_2_config)
	scene.init_players_data()
	scene.init_level_data()
	# when
	scene.add_game_elements()
	scene.init_game_elements()
	scene.disable_player_mouse_input(1)
	await wait_process_frames(10)
	# then
	# ==== check intro ====
	# checks ready text
	assert_eq(scene.get_game_message(), "Ready ?")
	# checks if can move but not use abilities
	assert_true(scene.get_player(1)._truce_active)
	assert_true(scene.get_player(2)._truce_active)
	_sender.action_down("fire").hold_for(.05)
	await _sender.idle
	_sender.release_all()
	assert_eq(scene.get_projectiles_count(),0)
	_sender.action_down("powerup").hold_for(.05)
	await _sender.idle
	_sender.release_all()
	assert_eq(scene.get_powerups_count(),0)
	var p1_ori_pos = scene.get_player(1).global_position
	_sender.action_down("left").action_down("movement_bonus").hold_for(.05)
	await _sender.idle
	_sender.release_all()
	await wait_seconds(0.1)
	assert_eq(scene.get_player(1).global_position.x,p1_ori_pos.x)
	_sender.action_down("jump").action_down("right").hold_for(.25)
	await _sender.idle
	_sender.release_all()
	await wait_seconds(0.2)
	assert_lt(scene.get_player(1).global_position.y, p1_ori_pos.y)
	assert_gt(scene.get_player(1).global_position.x, p1_ori_pos.x)
	# checks the countdown
	await wait_seconds(1)
	assert_eq(scene.get_game_message(), "3")
	await wait_seconds(1)
	assert_eq(scene.get_game_message(), "2")
	await wait_seconds(1)
	assert_eq(scene.get_game_message(), "1")
	# checks shoot and can use abilities
	await wait_seconds(1)
	assert_eq(scene.get_game_message(), "Shoot !")
	await wait_seconds(1)
	# ==== check movement and abilities ====
	_sender.action_down("fire").hold_for(.05)
	await _sender.idle
	_sender.release_all()
	await wait_process_frames(2)
	assert_eq(scene.get_projectiles_count(),1)
	_sender.action_down("powerup").hold_for(.05)
	await _sender.idle
	_sender.release_all()
	await wait_process_frames(2)
	assert_eq(scene.get_powerups_count(),1)
	p1_ori_pos = scene.get_player(1).global_position
	_sender.action_down("left").action_down("movement_bonus").hold_for(.05)
	await _sender.idle
	_sender.release_all()
	await wait_seconds(0.25)
	assert_lt(scene.get_player(1).global_position.x,p1_ori_pos.x)
