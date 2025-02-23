extends TileMapLayer
# destructible wall script

##### VARIABLES #####
#---- CONSTANTS -----
const WALL_COLOR_GRADIENT_RES_PATH := "res://Scenes/DestructibleWalls/wall_color_gradient.tres"
const DAMAGE_WALL_TRESHOLDS := [0,1500,3000]
# 0 - 1500 : light, 1500 - 3000 : medium, 3000 - inf : high

#---- EXPORTS -----
@export var BASE_HEALTH := 5000 
@export var BOUNCE_BACK_FORCE := 1750
@export var BOUNCE_BACK_DIRECTION := Vector2.RIGHT
@export var HEALTH = BASE_HEALTH

#---- STANDARD -----
#==== PUBLIC ====

#==== PRIVATE ====
var _velocity_buffer := {
	velocity= Vector2.ZERO,
	body= Node2D
}

#==== ONREADY ====
@onready var _wall_gradient := load(WALL_COLOR_GRADIENT_RES_PATH)
@onready var onready_paths := {
	"respawn_timer": $"RespawnTimer",
	"buffer_timer": $"VelocityBufferTimer",
	"freeze_timer": $"FreezePlayerTimer",
	"wait_respawn_timer" :$"WaitRespawnTimer",
	"damage_wall_area": $"DamageWallArea",
	"collision_detection_area": $"CollisionDetectionArea",
	"cracks": $"Cracks"
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
		rpc("_shake_camera_by_velocity",velocity.x)
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

func _get_max_velocity_in_buffer(velocity_buffer : Array) -> Vector2:
	var max_vel = velocity_buffer[0]
	for velocity in velocity_buffer:
		if BOUNCE_BACK_DIRECTION.x != 0 and abs(velocity.x) > max_vel.x:
			max_vel = velocity
		elif BOUNCE_BACK_DIRECTION.y != 0 and abs(velocity.y) > max_vel.y:
			max_vel = velocity
	return max_vel

# workaround to avoid a player stop just before the wall collision are disabled
func _buffer_player_velocity(body : Node2D, velocity: Vector2) -> void:
	_velocity_buffer.velocity = velocity
	_velocity_buffer.body = body

@rpc("authority","call_local","unreliable")
func _shake_camera_by_velocity(velocity : float) -> void:
	var camera_shake = _get_shake_type_by_velocity(abs(velocity))
	CameraEffects.emit_signal_start_camera_impact(1,camera_shake, CameraEffects.CAMERA_IMPACT_PRIORITY.HIGH)

func _get_shake_type_by_velocity(velocity : float) -> CameraEffects.CAMERA_IMPACT_INTENSITY:
	if FunctionUtils.in_between(velocity,DAMAGE_WALL_TRESHOLDS[0], DAMAGE_WALL_TRESHOLDS[1]):
		return CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT
	elif FunctionUtils.in_between(velocity,DAMAGE_WALL_TRESHOLDS[1], DAMAGE_WALL_TRESHOLDS[2]):
		return CameraEffects.CAMERA_IMPACT_INTENSITY.MEDIUM
	elif velocity > DAMAGE_WALL_TRESHOLDS[2]:
		return CameraEffects.CAMERA_IMPACT_INTENSITY.HIGH
	# should not go here
	return CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT

func _check_and_respawn() -> void:
	if onready_paths.collision_detection_area.has_overlapping_bodies(): # if there is a player already inside the wall at the time, wait a bit before trying to respawn it
		Logger.debug("wait before respawning")
		onready_paths.wait_respawn_timer.start()
	else: 
		rpc("_toggle_activated",true)
		_toggle_respawn_collision_detection_activated(false)


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
		onready_paths.freeze_timer.start()
		_buffer_player_velocity(body, max_velocity)
		if HEALTH <= 0:
			onready_paths.respawn_timer.start()
			rpc("_toggle_activated", false)
			_toggle_respawn_collision_detection_activated(true)

func _on_freeze_player_timer_timeout() -> void:
	if RuntimeUtils.is_authority():
		var body = _velocity_buffer.body
		_velocity_buffer.body.toggle_freeze(false)
		if HEALTH <= 0:
			_velocity_buffer.body.override_velocity(_velocity_buffer.velocity)
		else:
			_velocity_buffer.body.override_velocity(BOUNCE_BACK_DIRECTION * BOUNCE_BACK_FORCE)
		_velocity_buffer.body = Node2D
		_velocity_buffer.velocity = Vector2.ZERO
		

func _on_wait_for_respawn_timer_timeout() -> void:
	_check_and_respawn()
