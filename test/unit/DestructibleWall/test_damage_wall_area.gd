extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var damage_wall_area

##### SETUP #####
func before_each():
	damage_wall_area = load("res://Scenes/DestructibleWalls/damage_wall_area.gd").new()

##### TEARDOWN #####
func after_each():
	damage_wall_area.free()

##### TESTS #####
func test_update_size_in_editor():
	# given
	var mock_engine = double(load("res://test/unit/DestructibleWall/test_damage_wall_area_mocks/engine_mock.gd")).new()
	stub(mock_engine, "is_editor_hint").to_return(true)
	damage_wall_area._engine = mock_engine
	var mock_tilemap = double(TileMap).new()
	var tilemap_rect = Rect2i(Vector2i(10, 20), Vector2i(30, 40))
	stub(mock_tilemap, "get_used_rect").to_return(tilemap_rect)
	mock_tilemap.get_used_rect()
	damage_wall_area.tilemap = mock_tilemap
	var mock_collision_shape = CollisionShape2D.new()
	mock_collision_shape.shape = RectangleShape2D.new()
	damage_wall_area.collision_shape = mock_collision_shape
	# when
	damage_wall_area._update_size()
	# then
	assert_eq(Vector2i(damage_wall_area.position),tilemap_rect.position * 64 + tilemap_rect.size * 64 / 2)
	assert_eq(Vector2i(damage_wall_area.collision_shape.shape.size), tilemap_rect.size * 64 + Vector2i.ONE * 32)
	# cleanup
	mock_collision_shape.free()

func test_process_in_editor_calls_update_size():
	# given
	var mock_engine = double(load("res://test/unit/DestructibleWall/test_damage_wall_area_mocks/engine_mock.gd")).new()
	stub(mock_engine,"is_editor_hint").to_return(true)
	damage_wall_area._engine = mock_engine
	var mock_tilemap = double(TileMap).new()
	var tilemap_rect = Rect2i(Vector2i(10, 20), Vector2i(30, 40))
	stub(mock_tilemap, "get_used_rect").to_return(tilemap_rect)
	mock_tilemap.get_used_rect()
	damage_wall_area.tilemap = mock_tilemap
	var mock_collision_shape = CollisionShape2D.new()
	mock_collision_shape.shape = RectangleShape2D.new()
	damage_wall_area.collision_shape = mock_collision_shape
	# when
	damage_wall_area._process(0.1)
	# then
	assert_eq(Vector2i(damage_wall_area.position), tilemap_rect.position * 64 + tilemap_rect.size * 64 / 2)
	assert_eq(Vector2i(damage_wall_area.collision_shape.shape.size), tilemap_rect.size * 64 + Vector2i.ONE * 32)
	# cleanup
	mock_collision_shape.free()

func test_process_not_in_editor_skips_update():
	# given
	var mock_engine = double(load("res://test/unit/DestructibleWall/test_damage_wall_area_mocks/engine_mock.gd")).new()
	stub(mock_engine,"is_editor_hint").to_return(false)
	damage_wall_area._engine = mock_engine
	var mock_tilemap = double(TileMap).new()
	stub(mock_tilemap, "get_used_rect").to_do_nothing()
	# when
	damage_wall_area._process(0.1)
	# then
	assert_not_called(mock_tilemap, "get_used_rect")
