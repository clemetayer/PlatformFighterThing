extends TileMapLayer
# destructible wall script

##### SIGNALS #####
signal explode_fragments(force : Vector2)

##### VARIABLES #####
#---- CONSTANTS -----
const WALL_COLOR_GRADIENT_RES_PATH := "res://Scenes/DestructibleWalls/wall_color_gradient.tres"
const DAMAGE_WALL_TRESHOLD_EFFECT := 3000
# 0 - 1500 : light, 1500 - 3000 : medium, 3000 - inf : high
const FREEZE_PLAYER_TIMEOUT := 1 # s
const VORONOI_MAX_DESTRUCTION_PERCENTS := 0.5
const WALL_BREAK_KNOCKBACK_STRENGTH := 10000

#---- EXPORTS -----
@export var BASE_HEALTH := 5000 
@export var BOUNCE_BACK_FORCE := 1750
@export var BOUNCE_BACK_DIRECTION := Vector2.RIGHT
@export var HEALTH = BASE_HEALTH

#---- STANDARD -----
#==== PUBLIC ====

#==== PRIVATE ====
var _update_health_tween : Tween

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
		"break":$"Audio/WallBreak",
		"trebble":$"Audio/WallHitBreakTrebble"
	}
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_toggle_activated(true)
	_toggle_respawn_collision_detection_activated(false)
	_update_texture_color(BASE_HEALTH)

##### PROTECTED METHODS #####
func _get_damage(velocity) -> float:
	if BOUNCE_BACK_DIRECTION.x != 0:
		return abs(velocity.x)
	return abs(velocity.y)
	
func _remove_health_by_velocity(velocity: Vector2) -> void:
	var final_health = HEALTH - _get_damage(velocity)
	if BOUNCE_BACK_DIRECTION.x != 0:
		rpc("_shake_camera_by_velocity", velocity.x)
	elif BOUNCE_BACK_DIRECTION.y != 0:
		rpc("_shake_camera_by_velocity", velocity.y)
	_play_break_trebble(final_health)
	if _update_health_tween:
		_update_health_tween.kill() # Abort the previous animation.
	_update_health_tween = create_tween()
	_update_health_tween.tween_method(_update_health, HEALTH, final_health,FREEZE_PLAYER_TIMEOUT)
	rpc("_update_texture_color", HEALTH)

func _update_health(new_health : float) -> void:
	HEALTH = new_health
	rpc("_update_texture_color", new_health)

func _play_break_trebble(final_health : float) -> void:
	var final_damage_ratio = min(1.0 - final_health/BASE_HEALTH, 1.0)
	var final_stream_play_time = onready_paths.audio.trebble.stream.get_length() * final_damage_ratio
	var initial_stream_play_time = max(0.0,final_stream_play_time - FREEZE_PLAYER_TIMEOUT)
	onready_paths.audio.trebble.play(initial_stream_play_time)

@rpc("authority","call_local","unreliable")
func _update_texture_color(new_health: float) -> void:
	var health_ratio =(BASE_HEALTH - new_health)/BASE_HEALTH
	modulate = _wall_gradient.sample(health_ratio)
	onready_paths.cracks.material.set_shader_parameter("destruction_amount", health_ratio * VORONOI_MAX_DESTRUCTION_PERCENTS)

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
	CameraEffects.emit_signal_start_camera_impact(FREEZE_PLAYER_TIMEOUT,camera_shake, CameraEffects.CAMERA_IMPACT_PRIORITY.HIGH)

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

func _start_freeze_timeout_timer_for_player(player : Node2D, time : float = FREEZE_PLAYER_TIMEOUT) -> void:
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = time
	timer.connect("timeout",func(): _on_freeze_player_timer_timeout(timer, player))
	onready_paths.freeze_timers_path.add_child(timer)
	timer.start()

@rpc()
func _play_break_animation() -> void:
	FullScreenEffects.monochrome(2)
	FullScreenEffects.pincushion(2)
	rpc("_shake_camera_by_velocity", WALL_BREAK_KNOCKBACK_STRENGTH)
	await get_tree().create_timer(2).timeout

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
		var final_health = HEALTH - _get_damage(max_velocity)
		if final_health <= 0:
			HEALTH = final_health
			onready_paths.audio.break.play()
			onready_paths.respawn_timer.start()
			body.respawn()
			CameraEffects.emit_signal_focus_on(body.global_position,0.5,8.0,2)
			rpc("_play_break_animation")
			emit_signal("explode_fragments", max_velocity)
			rpc("_toggle_activated", false)
			_toggle_respawn_collision_detection_activated(true)
		else:
			body.toggle_freeze(true)
			_start_freeze_timeout_timer_for_player(body)
			_remove_health_by_velocity(max_velocity)
			onready_paths.audio.hit.play()

func _on_freeze_player_timer_timeout(timer_to_free : Timer, player : Node2D) -> void:
	if RuntimeUtils.is_authority() and is_instance_valid(player):
		player.toggle_freeze(false)
		onready_paths.audio.trebble.stop()
		if HEALTH <= 0:
			player.override_velocity(-BOUNCE_BACK_DIRECTION.normalized() * WALL_BREAK_KNOCKBACK_STRENGTH)
		else:
			player.override_velocity(BOUNCE_BACK_DIRECTION.normalized() * BOUNCE_BACK_FORCE)
		timer_to_free.queue_free()
		

func _on_wait_for_respawn_timer_timeout() -> void:
	_check_and_respawn()
