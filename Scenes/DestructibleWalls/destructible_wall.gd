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

#---- STANDARD -----
#==== PUBLIC ====
var health = BASE_HEALTH

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
	"damage_wall_area": $"DamageWallArea"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_toggle_activated(true)
	_update_texture_color()


##### PROTECTED METHODS #####
func _remove_health_by_velocity(velocity: Vector2) -> void:
	if BOUNCE_BACK_DIRECTION.x != 0:
		health -= abs(velocity.x)
		_shake_camera_by_velocity(velocity.x)
	elif BOUNCE_BACK_DIRECTION.y != 0:
		health -= abs(velocity.y)
		_shake_camera_by_velocity(velocity.y)
	_update_texture_color()

func _update_texture_color() -> void:
	var health_ratio =(BASE_HEALTH - health)/BASE_HEALTH
	modulate = _wall_gradient.sample(health_ratio)

func _toggle_activated(active : bool) -> void:
	visible = active
	collision_enabled = active
	onready_paths.damage_wall_area.set_deferred("monitoring", active)
	onready_paths.damage_wall_area.set_deferred("monitorable", active)

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

func _shake_camera_by_velocity(velocity : float) -> void:
	var camera_shake = _get_shake_type_by_velocity(abs(velocity))
	CameraEffects.emit_signal("start_camera_shake",1,camera_shake)

func _get_shake_type_by_velocity(velocity : float) -> CameraEffects.CAMERA_SHAKE_INTENSITY:
	if FunctionUtils.in_between(velocity,DAMAGE_WALL_TRESHOLDS[0], DAMAGE_WALL_TRESHOLDS[1]):
		return CameraEffects.CAMERA_SHAKE_INTENSITY.LIGHT
	elif FunctionUtils.in_between(velocity,DAMAGE_WALL_TRESHOLDS[1], DAMAGE_WALL_TRESHOLDS[2]):
		return CameraEffects.CAMERA_SHAKE_INTENSITY.MEDIUM
	elif velocity > DAMAGE_WALL_TRESHOLDS[2]:
		return CameraEffects.CAMERA_SHAKE_INTENSITY.HIGH
	# should not go here
	return CameraEffects.CAMERA_SHAKE_INTENSITY.LIGHT

##### SIGNAL MANAGEMENT #####
func _on_area_entered(area):
	if area.is_in_group("projectile"):
		area.queue_free()

func _on_respawn_timer_timeout() -> void:
	health = BASE_HEALTH
	_update_texture_color()
	_toggle_activated(true)

func _on_damage_wall_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and collision_enabled:
		var max_velocity = _get_max_velocity_in_buffer(body.velocity_buffer)
		_remove_health_by_velocity(max_velocity)
		body.toggle_freeze(true)
		onready_paths.freeze_timer.start()
		_buffer_player_velocity(body, max_velocity)
		if health <= 0:
			onready_paths.respawn_timer.start()
			_toggle_activated(false)

func _on_freeze_player_timer_timeout() -> void:
	var body = _velocity_buffer.body
	_velocity_buffer.body.toggle_freeze(false)
	if health <= 0:
		_velocity_buffer.body.override_velocity(_velocity_buffer.velocity)
	else:
		_velocity_buffer.body.override_velocity(BOUNCE_BACK_DIRECTION * BOUNCE_BACK_FORCE)
	_velocity_buffer.body = Node2D
	_velocity_buffer.velocity = Vector2.ZERO
		
