extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var health_manager
var health_empty_triggered := false
var health_changed_triggered := false
var health_changed_args := []

##### SETUP #####
func before_each():
	health_manager = load("res://Scenes/DestructibleWalls/health_manager.gd").new()
	health_empty_triggered = false
	health_changed_triggered = false
	health_changed_args = []

##### TEARDOWN #####
func after_each():
	health_manager.free()

##### TESTS #####
func test_init():
	# given
	var base_health = 100.0
	health_manager.connect("health_empty", _on_health_manager_health_empty)
	health_manager.connect("health_changed", _on_health_manager_health_changed)
	# when
	health_manager.init(base_health)
	# then
	assert_eq(health_manager.HEALTH, base_health)
	assert_eq(health_manager._base_health, base_health)
	assert_false(health_empty_triggered)
	assert_false(health_changed_triggered)

func test_apply_damage_not_empty():
	# given
	var base_health = 100.0
	var damage = 30.0
	health_manager.connect("health_empty", _on_health_manager_health_empty)
	health_manager.connect("health_changed", _on_health_manager_health_changed)
	health_manager.HEALTH = base_health
	health_manager._base_health = base_health
	# when
	health_manager.apply_damage(damage)
	wait_frames(1)
	# then
	assert_eq(health_manager.HEALTH, base_health - damage)
	assert_false(health_empty_triggered)
	assert_true(health_changed_triggered)
	assert_eq(health_changed_args[0], base_health - damage)
	assert_eq(health_changed_args[1], base_health)

func test_apply_damage_to_empty():
	# given
	var base_health = 100.0
	var damage = 150.0
	health_manager.connect("health_empty", _on_health_manager_health_empty)
	health_manager.connect("health_changed", _on_health_manager_health_changed)
	health_manager.HEALTH = base_health
	health_manager._base_health = base_health
	# when
	health_manager.apply_damage(damage)
	wait_frames(1)
	# then
	assert_eq(health_manager.HEALTH, 0.0)
	assert_true(health_empty_triggered)
	assert_false(health_changed_triggered)

func test_apply_damage_exact_to_empty():
	# given
	var base_health = 100.0
	var damage = 100.0
	health_manager.connect("health_empty", _on_health_manager_health_empty)
	health_manager.connect("health_changed", _on_health_manager_health_changed)
	health_manager.HEALTH = base_health
	health_manager._base_health = base_health
	# when
	health_manager.apply_damage(damage)
	wait_frames(1)
	# then
	assert_eq(health_manager.HEALTH, 0.0)
	assert_true(health_empty_triggered)
	assert_false(health_changed_triggered)

func test_reset_health():
	# given
	var base_health = 100.0
	var damage = 30.0
	health_manager.connect("health_changed", _on_health_manager_health_changed)
	health_manager.HEALTH = base_health
	health_manager._base_health = base_health
	# when
	health_manager.apply_damage(damage)
	wait_frames(1)
	health_changed_triggered = false
	health_changed_args = []
	health_manager.reset_health()
	wait_frames(1)
	# then
	assert_eq(health_manager.HEALTH, base_health)
	assert_true(health_changed_triggered)
	assert_eq(health_changed_args[0], base_health)
	assert_eq(health_changed_args[1], base_health)


var get_health_ratio_parameters := [
	[25.0,0.75],
	[100.0,0.0]
]
func test_get_health_ratio(params = use_parameters(get_health_ratio_parameters)):
	# given
	var base_health = 100.0
	var damage = params[0]
	health_manager.HEALTH = base_health
	health_manager._base_health = base_health
	health_manager.apply_damage(damage)
	# when
	var result = health_manager.get_health_ratio()
	# then
	assert_eq(result, params[1])


var is_destroyed_params := [
	[100.0,true],
	[50.0,false]
]
func test_is_destroyed(params = use_parameters(is_destroyed_params)):
	# given
	var base_health = 100.0
	var damage = params[0]
	health_manager.HEALTH = base_health
	health_manager._base_health = base_health
	health_manager.apply_damage(damage)
	# when
	var result = health_manager.is_destroyed()
	# then
	assert_eq(result,params[1])

##### UTILS #####
func _on_health_manager_health_empty():
	health_empty_triggered = true

func _on_health_manager_health_changed(new_health : float, old_health : float):
	health_changed_triggered = true
	health_changed_args = [new_health, old_health]
