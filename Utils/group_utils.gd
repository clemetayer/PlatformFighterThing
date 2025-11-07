extends RefCounted
class_name GroupUtils
# Utils to determine if a node is in a specific group, to avoid using magic strings everywhere

##### VARIABLES #####
#---- CONSTANTS -----
const PROJECTILE_GROUP_NAME := "projectile"
const PLAYER_GROUP_NAME := "player"
const DESTRUCTIBLE_WALL_GROUP_NAME := "destructible_wall"
const STATIC_OBSTACLE_GROUP_NAME := "static_obstacle"

##### PUBLIC METHODS #####
static func is_projectile(projectile: Node2D) -> bool:
	return _is_in_group_common(projectile, PROJECTILE_GROUP_NAME)

static func is_player(player: Node2D) -> bool:
	return _is_in_group_common(player, PLAYER_GROUP_NAME)

static func is_destructible_wall(wall: Node2D) -> bool:
	return _is_in_group_common(wall, DESTRUCTIBLE_WALL_GROUP_NAME)

static func is_static_obstacle(obstacle: Node2D) -> bool:
	return _is_in_group_common(obstacle, STATIC_OBSTACLE_GROUP_NAME)

##### PROTECTED METHODS #####
static func _is_in_group_common(node: Node, group_name: String) -> bool:
	return node != null and node.is_in_group(group_name)
