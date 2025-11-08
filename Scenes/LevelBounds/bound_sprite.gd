extends Sprite2D
# Handles the Sprite showing the area

##### VARIABLES #####
#---- CONSTANTS -----
const BASE_TEXTURE_SIZE := 1024.0
const BORDER_SCALE_MULTIPLIER := 2.0
const DEFAULT_PLAYER_UV_POSITION := Vector2.ONE * 999
const SHADER_PARAM_PLAYERS_POSITIONS_NAME := "players_uv_positions"
const SHADER_PARAM_PLAYERS_POSITIONS_SIZE := 8
const SHADER_PARAM_SPRITE_SCALE_NAME := "sprite_scale"

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	var shape := _get_collision_shape()
	if shape != null:
		_set_scale_with_shape(shape)
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

func _get_players_positions() -> Array:
	var players = _get_players()
	if players != null and players.size() > 0:
		return players.map(func(player): return player.global_position)
	GSLogger.warn("No players found to compute the bound sprite limit")
	return []

func _set_scale_with_shape(shape: CollisionShape2D) -> void:
	scale = (shape.shape.size * 2.0) / BASE_TEXTURE_SIZE
	material.set_shader_parameter(SHADER_PARAM_SPRITE_SCALE_NAME, scale)

func _set_shader_players_positions(players_positions: Array) -> void:
	var uv_positions = players_positions.map(_convert_to_shader_uv_position)
	if players_positions.size() < SHADER_PARAM_PLAYERS_POSITIONS_SIZE:
		for fill_idx in range(players_positions.size() - 1, SHADER_PARAM_PLAYERS_POSITIONS_SIZE - 1):
			uv_positions.append(DEFAULT_PLAYER_UV_POSITION)
	material.set_shader_parameter(SHADER_PARAM_PLAYERS_POSITIONS_NAME, uv_positions)

func _convert_to_shader_uv_position(player_position: Vector2) -> Vector2:
	var global_origin = global_position - BASE_TEXTURE_SIZE * scale / BORDER_SCALE_MULTIPLIER
	return (player_position - global_origin) / (BASE_TEXTURE_SIZE * scale)

func _get_players() -> Array:
	return get_tree().get_nodes_in_group(GroupUtils.PLAYER_GROUP_NAME)
