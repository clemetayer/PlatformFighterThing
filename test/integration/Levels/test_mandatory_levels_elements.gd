extends "res://addons/gut/test.gd"

##### TESTS #####
var mandatory_elements_params := [
	["res://Scenes/Levels/Level1/level_1_map.tscn"]
]
func test_mandatory_elements(params = use_parameters(mandatory_elements_params)):
	# given
	var level = load(params[0]).instantiate()
	add_child_autofree(level)
	# when/then
	_should_have_spawn_points(level)
	_should_have_level_bounds(level)
	assert_true(_has_level_a_static_tilemap(level))
	_should_have_destructible_walls(level)
	_each_destructible_wall_should_have_particles_attached(level)
	

##### UTILS #####
func _should_have_spawn_points(level) -> void:
	assert_true(level.has_method("get_spawn_points"))
	assert_gt(level.get_spawn_points().size(), 0)
	for spawn_point in level.get_spawn_points():
		assert_true(spawn_point is Vector2)

func _should_have_level_bounds(_level) -> void:
	assert_gt(get_tree().get_nodes_in_group("level_bounds").size(), 0)

func _has_level_a_static_tilemap(level) -> bool:
	var tilemaps = level.find_children("*", "TileMapLayer")
	for tilemap in tilemaps:
		if tilemap.is_in_group("static_obstacle"):
			return true
	return false
			
func _should_have_destructible_walls(_level) -> void:
	assert_gt(get_tree().get_nodes_in_group("destructible_wall").size(), 0)

func _each_destructible_wall_should_have_particles_attached(_level) -> void:
	var destructible_walls = get_tree().get_nodes_in_group("destructible_wall")
	var particles = get_tree().get_nodes_in_group("wall_break_particles")
	assert_eq(destructible_walls.size(), particles.size())
	for wall in destructible_walls:
		assert_true(_destructible_wall_linked_to_a_wall_break_particles(wall, particles))

func _destructible_wall_linked_to_a_wall_break_particles(wall : Node2D, particles : Array) -> bool:
	for particle in particles:
		if particle._tilemap == wall:
			return true
	return false
