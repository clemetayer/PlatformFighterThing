extends Polygon2D
# Handles the Sprite showing the area

##### VARIABLES #####
#---- CONSTANTS -----
const BASE_TEXTURE_SIZE := 1024.0
const DEFAULT_PLAYER_UV_POSITION := Vector2.ONE * 999
const SHADER_PARAM_PLAYERS_POSITIONS_NAME := "players_uv_positions"
const SHADER_PARAM_PLAYERS_POSITIONS_SIZE := 8

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	var shape := _get_collision_shape()
	if shape != null:
		_set_polygon_with_shape(shape)
		_set_offset_with_shape(shape)
		_set_border_with_shape(shape)
		_set_offset_with_shape(shape)
	else:
		GSLogger.error("Error setting the collision shape sprite : no CollisionShape found in parent")

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	_set_shader_players_positions(_get_players_positions())

##### PROTECTED METHODS #####
func _get_collision_shape() -> CollisionShape2D:
	for node in get_parent().get_children():
		if node is CollisionShape2D:
			return node
	return null

func _set_polygon_with_shape(shape: CollisionShape2D) -> void:
	position = shape.position - shape.shape.size
	var points := []
	for row_idx in range(0, 2):
		for col_idx in range(0, 2):
			points.append(Vector2(shape.shape.size.x * row_idx, shape.shape.size.y * col_idx))
	return PackedVector2Array(points)

func _set_offset_with_shape(shape: CollisionShape2D) -> void:
	offset = shape.shape.size / 2.0

func _set_texture_scale_with_shape(shape: CollisionShape2D) -> void:
	texture_scale = BASE_TEXTURE_SIZE / shape.shape.size

func _set_border_with_shape(shape: CollisionShape2D) -> void:
	invert_border = max(shape.shape.size.x, shape.shape.size.y) / 2.0

func _get_players_positions() -> Array:
	var players = get_tree().get_nodes_in_group(GroupUtils.PLAYER_GROUP_NAME)
	if players != null and players.size() > 0:
		return players.map(func(player): return player.global_position)
	GSLogger.warn("No players found to compute the bound sprite limit")
	return []

func _set_shader_players_positions(players_positions: Array) -> void:
	var uv_positions = players_positions.map(_convert_to_shader_uv_position)
	if players_positions.size() < SHADER_PARAM_PLAYERS_POSITIONS_SIZE:
		for fill_idx in range(players_positions.size() - 1, SHADER_PARAM_PLAYERS_POSITIONS_SIZE):
			uv_positions.append(DEFAULT_PLAYER_UV_POSITION)
	GSLogger.debug(uv_positions)
	material.set_shader_parameter(SHADER_PARAM_PLAYERS_POSITIONS_NAME, uv_positions)

func _convert_to_shader_uv_position(player_position: Vector2) -> Vector2:
	var rect_size = _get_rectangle_size()
	var polygon_global_origin = global_position - Vector2.ONE * invert_border
	GSLogger.debug(polygon_global_origin)
	return (player_position - polygon_global_origin) / (max(rect_size.x, rect_size.y) + 2.0 * invert_border)

func _get_rectangle_size() -> Vector2:
	var rect_size = Vector2.ZERO
	for point in polygon:
		rect_size.x = max(rect_size.x, point.x)
		rect_size.y = max(rect_size.y, point.y)
	return rect_size
