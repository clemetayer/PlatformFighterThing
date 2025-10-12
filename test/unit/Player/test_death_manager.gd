extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var death_manager
var game_message_triggered_times_called := 0
var game_message_triggered_args := []
var toggle_freeze_times_called := 0
var toggle_freeze_args := []
var set_collision_layer_times_called := 0
var set_collision_layer_args := []
var set_collision_mask_times_called := 0
var set_collision_mask_args := []
var killed_times_called := 0
var killed_args := []
var toggle_truce_times_called := 0
var toggle_truce_args := []

##### SETUP #####
func before_each():
	death_manager = load("res://Scenes/Player/death_manager.gd").new()
	game_message_triggered_times_called = 0
	game_message_triggered_args = []
	toggle_freeze_times_called = 0
	toggle_freeze_args = []
	set_collision_layer_args = []
	set_collision_layer_times_called = 0
	set_collision_mask_times_called = 0
	set_collision_mask_args = []
	killed_times_called = 0
	killed_args = []
	toggle_truce_times_called = 0
	toggle_truce_args = []

##### TEARDOWN #####
func after_each():
	death_manager.free()

##### TESTS #####
func test_set_particles_color():
	# given
	var particles = GPUParticles2D.new()
	death_manager.onready_paths.particles = particles
	# when
	death_manager.set_particles_color(Color.ALICE_BLUE)
	# then
	assert_eq(death_manager.onready_paths.particles.modulate, Color.ALICE_BLUE)
	# cleanup
	particles.free()

func test_set_last_hit_owner():
	# given
	var last_hit_owner = Node2D.new()
	# when
	death_manager.set_last_hit_owner(last_hit_owner)
	# then
	assert_eq(death_manager._last_hit_owner, last_hit_owner)
	# cleanup
	last_hit_owner.free()

func test_kill():
	# given
	var camera_effects = double(load("res://Scenes/Camera/camera_effects.gd")).new()
	stub(camera_effects, "emit_signal_start_camera_impact").to_do_nothing()
	death_manager._camera_effects = camera_effects
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	death_manager.onready_paths_node = onready_paths_node
	var last_hit_owner = load("res://test/unit/Player/test_death_manager/player_root.gd").new()
	last_hit_owner.id = 123
	death_manager._last_hit_owner = last_hit_owner
	var particles = GPUParticles2D.new()
	death_manager.onready_paths.particles = particles
	var player_root = load("res://test/unit/Player/test_death_manager/player_root.gd").new()
	player_root.connect("game_message_triggered", _on_game_message_triggered)
	player_root.connect("toggle_freeze_called", _on_toggle_freeze)
	player_root.connect("set_collision_layer_called", _on_set_collision_layer)
	player_root.connect("set_collision_mask_called", _on_set_collision_mask)
	player_root.connect("toggle_truce_called", _on_toggle_truce)
	add_child(player_root)
	death_manager.onready_paths_node.player_root = player_root
	var damage_label = double(Control).new()
	stub(damage_label, "hide").to_do_nothing()
	death_manager.onready_paths_node.damage_label = damage_label
	var sprites = double(Sprite2D).new()
	stub(sprites, "hide").to_do_nothing()
	death_manager.onready_paths_node.sprites = sprites
	var primary_weapon = double(Node2D).new()
	stub(primary_weapon, "hide").to_do_nothing()
	death_manager.onready_paths_node.primary_weapon = primary_weapon
	var sound = double(AudioStreamPlayer).new()
	stub(sound, "play").to_do_nothing()
	stub(sound, "is_inside_tree").to_return(true)
	death_manager.onready_paths.sound = sound
	var death_anim_time = double(Timer).new()
	stub(death_anim_time, "start").to_do_nothing()
	stub(death_anim_time, "is_inside_tree").to_return(true)
	death_manager.onready_paths.death_anim_time = death_anim_time
	# when
	death_manager.kill()
	# then
	assert_called(camera_effects, "emit_signal_start_camera_impact", [death_manager.CAMERA_DEATH_IMPACT_TIME * 1.0, CameraEffects.CAMERA_IMPACT_INTENSITY.HIGH, CameraEffects.CAMERA_IMPACT_PRIORITY.HIGH])
	assert_eq(game_message_triggered_times_called, 1)
	assert_eq(game_message_triggered_args, [[123]])
	assert_eq(toggle_freeze_times_called, 1)
	assert_eq(toggle_freeze_args, [[true]])
	assert_eq(set_collision_layer_times_called, 1)
	assert_eq(set_collision_layer_args, [[0]])
	assert_eq(set_collision_mask_times_called, 1)
	assert_eq(set_collision_mask_args, [[0]])
	assert_eq(toggle_truce_times_called, 1)
	assert_eq(toggle_truce_args, [[true]])
	assert_called(damage_label, "hide")
	assert_called(primary_weapon, "hide")
	assert_called(sound, "play")
	assert_called(death_anim_time, "start")
	assert_true(particles.emitting)
	# cleanup
	last_hit_owner.free()
	player_root.free()
	onready_paths_node.free()
	particles.free()

func test_get_last_hit_owner_id_valid():
	# given
	var last_hit_owner = load("res://test/unit/Player/test_death_manager/player_root.gd").new()
	death_manager._last_hit_owner = last_hit_owner
	last_hit_owner.id = 123
	# when
	var res = death_manager._get_last_hit_owner_id(last_hit_owner)
	# then
	assert_eq(res, 123)
	# cleanup
	last_hit_owner.free()

func test_get_last_hit_owner_id_invalid():
	# given
	var last_hit_owner = Node2D.new()
	death_manager._last_hit_owner = last_hit_owner
	# when
	var res = death_manager._get_last_hit_owner_id(last_hit_owner)
	# then
	assert_eq(res, -1)
	# cleanup
	last_hit_owner.free()

func test_on_death_anim_time_timeout():
	# given
	var player_root = load("res://test/unit/Player/test_death_manager/player_root.gd").new()
	var onready_paths_node = load("res://Scenes/Player/paths.gd").new()
	onready_paths_node.player_root = player_root
	player_root.connect("killed", _on_killed)
	player_root.id = 123
	death_manager.onready_paths_node = onready_paths_node
	# when
	death_manager._on_death_anim_time_timeout()
	# then
	assert_eq(killed_times_called, 1)
	assert_eq(killed_args, [[123]])
	# cleanup
	player_root.free()
	onready_paths_node.free()

##### UTILS #####
func _on_game_message_triggered(id: int) -> void:
	game_message_triggered_times_called += 1
	game_message_triggered_args.append([id])

func _on_toggle_freeze(value: bool) -> void:
	toggle_freeze_times_called += 1
	toggle_freeze_args.append([value])

func _on_set_collision_layer(value) -> void:
	set_collision_layer_times_called += 1
	set_collision_layer_args.append([value])

func _on_set_collision_mask(value) -> void:
	set_collision_mask_times_called += 1
	set_collision_mask_args.append([value])

func _on_killed(id: int) -> void:
	killed_times_called += 1
	killed_args.append([id])

func _on_toggle_truce(value: bool) -> void:
	toggle_truce_times_called += 1
	toggle_truce_args.append([value])
