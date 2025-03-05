extends TileMapLayer
# destructible wall script

##### VARIABLES #####
#---- CONSTANTS -----
const WALL_COLOR_GRADIENT_RES_PATH := "res://Scenes/DestructibleWalls/wall_color_gradient.tres"
const DAMAGE_WALL_TRESHOLD_EFFECT := 3000
# 0 - 1500 : light, 1500 - 3000 : medium, 3000 - inf : high
const FREEZE_PLAYER_TIMEOUT := 1 # s

#---- EXPORTS -----
@export var BASE_HEALTH := 5000 
@export var BOUNCE_BACK_FORCE := 1750
@export var BOUNCE_BACK_DIRECTION := Vector2.RIGHT
@export var HEALTH = BASE_HEALTH

#---- STANDARD -----
#==== PUBLIC ====

#==== PRIVATE ====

#==== ONREADY ====
@onready var _wall_gradient := load(WALL_COLOR_GRADIENT_RES_PATH)
@onready var onready_paths := {
	"respawn_timer": $"RespawnTimer",
	"buffer_timer": $"VelocityBufferTimer",
	"freeze_timers_path": $"FreezePlayerTimers",
	"wait_respawn_timer" :$"WaitRespawnTimer",
	"damage_wall_area": $"DamageWallArea",
	"collision_detection_area": $"CollisionDetectionArea",
	"cracks": $"Cracks",
	"audio": {
		"hit":$"Audio/WallHit",
		"break":$"Audio/WallBreak"
	}
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_toggle_activated(true)
	_toggle_respawn_collision_detection_activated(false)
	_update_texture_color(BASE_HEALTH)

##### PROTECTED METHODS #####
func _remove_health_by_velocity(velocity: Vector2) -> void:
	if BOUNCE_BACK_DIRECTION.x != 0:
		HEALTH -= abs(velocity.x)
		rpc("_shake_camera_by_velocity", velocity.x)
	elif BOUNCE_BACK_DIRECTION.y != 0:
		HEALTH -= abs(velocity.y)
		rpc("_shake_camera_by_velocity", velocity.y)
	rpc("_update_texture_color", HEALTH)

@rpc("authority","call_local","unreliable")
func _update_texture_color(new_health: float) -> void:
	var health_ratio =(BASE_HEALTH - new_health)/BASE_HEALTH
	modulate = _wall_gradient.sample(health_ratio)
	onready_paths.cracks.material.set_shader_parameter("destruction_amount", health_ratio)

@rpc("authority","call_local","unreliable")
func _toggle_activated(active : bool) -> void:
	visible = active
	collision_enabled = active
	onready_paths.damage_wall_area.set_deferred("monitoring", active)
	onready_paths.damage_wall_area.set_deferred("monitorable", active)

@rpc("authority","call_local","unreliable")
func _toggle_respawn_collision_detection_activated(active : bool) -> void:
	onready_paths.collision_detection_area.set_deferred("monitoring", active)
	onready_paths.collision_detection_area.set_deferred("monitorable", active)

# REFACTOR : Maybe it could be a better idea to keep this in the player
func _get_max_velocity_in_buffer(velocity_buffer : Array) -> Vector2:
	var max_vel = velocity_buffer[0]
	for velocity in velocity_buffer:
		if BOUNCE_BACK_DIRECTION.x != 0 and abs(velocity.x) > max_vel.x:
			max_vel = velocity
		elif BOUNCE_BACK_DIRECTION.y != 0 and abs(velocity.y) > max_vel.y:
			max_vel = velocity
	return max_vel

@rpc("authority","call_local","unreliable")
func _shake_camera_by_velocity(velocity : float) -> void:
	var camera_shake = _get_shake_type_by_velocity(abs(velocity))
	CameraEffects.emit_signal_start_camera_impact(1,camera_shake, CameraEffects.CAMERA_IMPACT_PRIORITY.HIGH)

func _get_shake_type_by_velocity(velocity : float) -> CameraEffects.CAMERA_IMPACT_INTENSITY:
	if velocity <= DAMAGE_WALL_TRESHOLD_EFFECT:
		return CameraEffects.CAMERA_IMPACT_INTENSITY.MEDIUM
	else:
		return CameraEffects.CAMERA_IMPACT_INTENSITY.HIGH

func _check_and_respawn() -> void:
	if onready_paths.collision_detection_area.has_overlapping_bodies(): # if there is a player already inside the wall at the time, wait a bit before trying to respawn it
		Logger.debug("wait before respawning")
		onready_paths.wait_respawn_timer.start()
	else: 
		rpc("_toggle_activated",true)
		_toggle_respawn_collision_detection_activated(false)

func _start_freeze_timeout_timer_for_player(player_velocity : Vector2, player : Node2D) -> void:
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = FREEZE_PLAYER_TIMEOUT
	timer.connect("timeout",func(): _on_freeze_player_timer_timeout(timer, player_velocity, player))
	onready_paths.freeze_timers_path.add_child(timer)
	timer.start()

##### SIGNAL MANAGEMENT #####
func _on_area_entered(area):
	if area.is_in_group("projectile") and RuntimeUtils.is_authority():
		area.queue_free()

func _on_respawn_timer_timeout() -> void:
	HEALTH = BASE_HEALTH
	rpc("_update_texture_color", HEALTH)
	_check_and_respawn()


func _on_damage_wall_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and collision_enabled and RuntimeUtils.is_authority():
		var max_velocity = _get_max_velocity_in_buffer(body.velocity_buffer)
		_remove_health_by_velocity(max_velocity)
		body.toggle_freeze(true)
		_start_freeze_timeout_timer_for_player(body.velocity, body)
		if HEALTH <= 0:
			onready_paths.audio.break.play()
			onready_paths.respawn_timer.start()
			rpc("_toggle_activated", false)
			_toggle_respawn_collision_detection_activated(true)
		else:
			onready_paths.audio.hit.play()

func _on_freeze_player_timer_timeout(timer_to_free : Timer, player_velocity : Vector2, player : Node2D) -> void:
	if RuntimeUtils.is_authority():
		player.toggle_freeze(false)
		if HEALTH <= 0:
			player.override_velocity(player_velocity)
		else:
			player.override_velocity(BOUNCE_BACK_DIRECTION * BOUNCE_BACK_FORCE)
		timer_to_free.queue_free()
		

func _on_wait_for_respawn_timer_timeout() -> void:
	_check_and_respawn()
