extends Node2D
# Controls the collisions of the breakable wall

##### SIGNALS #####
signal player_hit(player, velocity)

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _bounce_back_direction := Vector2.RIGHT
var _latest_hit_velocity : Vector2
var _latest_hit_position : Vector2
var _runtime_utils := RuntimeUtils
var _group_utils = GroupUtils

#==== ONREADY ====
@onready var onready_paths := {
	"destructible_wall": $"../",
	"damage_wall_area" : $"DamageWallArea"
}

##### PUBLIC METHODS #####
func init(bounce_back_direction : Vector2) -> void:
	_bounce_back_direction = bounce_back_direction

func set_active(active: bool) -> void:
	onready_paths.damage_wall_area.set_deferred("monitoring", active)
	onready_paths.damage_wall_area.set_deferred("monitorable", active)

func get_latest_hit_velocity() -> Vector2:
	return _latest_hit_velocity

func get_latest_hit_position() -> Vector2:
	return _latest_hit_position

##### PROTECTED METHODS #####
func _get_max_velocity_in_buffer(velocity_buffer: Array) -> Vector2:
	var max_vel = velocity_buffer[0]
	for velocity in velocity_buffer:
		if _bounce_back_direction.x != 0 and abs(velocity.x) > abs(max_vel.x):
			max_vel = velocity
		elif _bounce_back_direction.y != 0 and abs(velocity.y) > abs(max_vel.y):
			max_vel = velocity
	return max_vel

##### SIGNAL MANAGEMENT #####
func _on_damage_wall_area_body_entered(body: Node2D) -> void:
	if _group_utils.is_player(body) and onready_paths.destructible_wall.get_collision_enabled() and _runtime_utils.is_authority():
		var max_velocity = _get_max_velocity_in_buffer(body.get_velocity_buffer())
		_latest_hit_position = body.get_global_position()
		_latest_hit_velocity = max_velocity
		emit_signal("player_hit", body, max_velocity)
