extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var splitter
var destroyed_times_called := 0
var destroyed_args := []

##### SETUP #####
func before_each():
	splitter = load("res://Scenes/Weapons/Powerups/Splitter/splitter.gd").new()
	destroyed_times_called = 0
	destroyed_args = []

##### TEARDOWN #####
func after_each():
	splitter.free()

##### TESTS #####
var spawn_projectile_params :=[
	[true],
	[false]
]
func test_spawn_projectile(params = use_parameters(spawn_projectile_params)):
	# given
	var is_authority = params[0]
	var projectile = Node2D.new()
	var runtime_utils = double(load("res://Utils/runtime_utils.gd")).new()
	stub(runtime_utils, "is_authority").to_return(is_authority)
	splitter._runtime_utils = runtime_utils
	var game_root = double(load("res://Scenes/Game/game.gd"), DOUBLE_STRATEGY.INCLUDE_NATIVE).new()
	stub(game_root, "spawn_projectile").to_do_nothing()
	stub(runtime_utils, "get_game_root").to_return(game_root)
	splitter._runtime_utils = runtime_utils
	# when
	splitter._spawn_projectile(projectile)
	# then
	if is_authority:
		assert_called(game_root, "spawn_projectile", [projectile])
	else:
		assert_not_called(game_root, "spawn_projectile")

func test_duplicate_projectile_with_angle():
	# given
	var projectile = load("res://Scenes/Weapons/Projectiles/Bullet/bullet.gd").new()
	var current_owner = Node2D.new()
	projectile.current_owner = current_owner
	var splitter_mock = partial_double(load("res://Scenes/Weapons/Powerups/Splitter/splitter.gd")).new()
	stub(splitter_mock, "_spawn_projectile").to_do_nothing()
	# when
	splitter_mock._duplicate_projectile_with_angle(projectile, PI/4.0)
	# then
	assert_called(splitter_mock, "_spawn_projectile")
	assert_eq(splitter_mock._whitelist.size(), 1)
	var duplicated_projectile = splitter_mock._whitelist[0]
	assert_eq(duplicated_projectile.current_owner, current_owner)
	assert_eq(duplicated_projectile.init_rotation, projectile.rotation + PI/4.0)
	assert_eq(duplicated_projectile.init_position, projectile.global_position)
	# cleanup
	duplicated_projectile.free()
	projectile.free()

func test_handle_feedback():
	# given
	var audio = double(AudioStreamPlayer).new()
	stub(audio, "play").to_do_nothing()
	var circles = double(load("res://Scenes/Weapons/Powerups/Splitter/circles.gd")).new()
	stub(circles, "remove_circle").to_do_nothing()
	var hit_effect = GPUParticles2D.new()
	hit_effect.emitting = false
	add_child_autofree(hit_effect)
	splitter.onready_paths.audio = audio
	splitter.onready_paths.circles = circles
	splitter.onready_paths.hit_effect = hit_effect
	# when
	splitter._handle_feedback()
	# then
	assert_called(audio, "play")
	assert_called(circles, "remove_circle")
	assert_true(hit_effect.emitting)

func test_prepare_for_deletion():
	# given
	var collision = CollisionShape2D.new()
	var sprite = Sprite2D.new()
	sprite.show()
	var audio = AudioStreamPlayer.new()
	audio.playing = true
	splitter.connect("destroyed", _on_destroyed)
	splitter.onready_paths.collision = collision
	splitter.onready_paths.sprite = sprite
	splitter.onready_paths.audio = audio
	# when
	splitter._prepare_for_deletion()
	# then
	assert_false(sprite.visible)
	assert_eq(destroyed_times_called, 1)
	assert_eq(destroyed_args, [[splitter]])
	# cleanup
	collision.free()
	sprite.free()
	audio.free()

var on_hitbox_area_entered_params := [
	[true, true, false, 1],
	[true, true, false, 999],
	[true, true, false, 1],
	[false, true, false, 1],
	[true, false, false, 1],
	[true, true, true, 1]
]
func test_on_hitbox_area_entered(params = use_parameters(on_hitbox_area_entered_params)):
	# given
	var is_authority = params[0]
	var is_projectile = params[1]
	var whitelist_has_area = params[2]
	var contacts_count = params[3]
	var mock_splitter = partial_double(load("res://Scenes/Weapons/Powerups/Splitter/splitter.tscn")).instantiate()
	stub(mock_splitter, "_duplicate_projectile_with_angle").to_do_nothing()
	stub(mock_splitter, "_ready").to_do_nothing()
	stub(mock_splitter, "_handle_feedback").to_do_nothing()
	stub(mock_splitter, "_prepare_for_deletion").to_do_nothing()
	add_child_autofree(mock_splitter)
	var runtime_utils = double(load("res://Utils/runtime_utils.gd")).new()
	stub(runtime_utils, "is_authority").to_return(is_authority)
	mock_splitter._runtime_utils = runtime_utils
	var area = Area2D.new()
	if is_projectile:
		area.add_to_group("projectile")
	if whitelist_has_area:
		mock_splitter._whitelist = [area]
	mock_splitter._contacts_count = contacts_count
	# when
	mock_splitter._on_hitbox_area_entered(area)
	# then
	if is_authority and is_projectile and not whitelist_has_area:
		for duplicate_idx in range(1, mock_splitter.PROJECTILE_DUPLICATES + 1):
			var dup_angle = (duplicate_idx * ((PI/2)/(mock_splitter.PROJECTILE_DUPLICATES+1))) - PI/4
			assert_called(mock_splitter, "_duplicate_projectile_with_angle", [area, dup_angle])
		if not mock_splitter.PROJECTILE_DUPLICATES % 2 == 0:
			assert_true(mock_splitter._whitelist.has(area))
		if contacts_count < mock_splitter.MAX_CONTACTS - 1:
			assert_eq(mock_splitter._contacts_count, contacts_count + 1)
	else:
		assert_not_called(mock_splitter, "_duplicate_projectile_with_angle")
	# cleanup 
	area.free()
	for d_area in mock_splitter._whitelist:
		if is_instance_valid(d_area):
			d_area.free()

var on_hitbox_area_exited_params = [
	[true, true],
	[true, false],
	[false, true]
]
func test_on_hitbox_area_exited(params = use_parameters(on_hitbox_area_exited_params)):
	# given
	var whitelist_has_area = params[0]
	var is_authority = params[1]
	var area = Area2D.new()
	if whitelist_has_area:
		splitter._whitelist.append(area)
	var runtime_utils = double(load("res://Utils/runtime_utils.gd")).new()
	stub(runtime_utils, "is_authority").to_return(is_authority)
	# when 
	splitter._on_hitbox_area_exited(area)
	# then 
	assert_eq(splitter._whitelist.size(), 0)
	# cleanup
	area.free()

##### UTILS #####
func _on_destroyed(node):
	destroyed_times_called += 1
	destroyed_args.append([node])
