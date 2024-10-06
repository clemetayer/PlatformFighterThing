extends RigidBody2D
# player script

##### SIGNALS #####
signal killed(id : int)

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const TARGET_SPEED := 750.0 # px/s
const JUMP_VELOCITY := -1200.0
const MAX_HITSTUN_TIME := 3 # s
const MAX_HITSTUN_DAMAGE := 999 # damage points
const MAX_FLOOR_ANGLE := PI/4
const NORMAL_BOUNCE = 0.05
const HITSTUN_BOUNCE = 1

#---- EXPORTS -----
@export var CONFIG : PlayerConfig
@export var DAMAGE := 0.0
@export var scene_player_id := 0 # id corresponding to the player in the scene its in. Different from the multiplayer id
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$InputSynchronizer.set_multiplayer_authority(id)

#---- STANDARD -----
#==== PUBLIC ====
var velocity := Vector2.ZERO
var direction := Vector2.ZERO
var velocity_buffer := [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO] # 3 frame buffer for the velocity. Usefull to keep track of the velocity when elements are going too fast

#==== PRIVATE ====
var _can_use_powerup := true
var _hitstunned := false
var _frozen := false
var _velocity_override := Vector2.ZERO
var _additional_vector := Vector2.ZERO # external forces that can have an effect on the player and needs to be added to the velocity on the next physics frame

#==== ONREADY ====
@onready var FLOOR_ACCELERATION = 100.0 * ProjectSettings.get_setting("physics/common/physics_ticks_per_second") # px/s² # Kind of a constant, that's why it is in all caps
@onready var AIR_ACCELERATION = 50.0 * ProjectSettings.get_setting("physics/common/physics_ticks_per_second") # px/s² # Kind of a constant, that's why it is in all caps
@onready var onready_paths := {
	"primary_weapon":StaticPrimaryWeaponHandler.get_weapon(CONFIG.PRIMARY_WEAPON),
	"movement_bonus":StaticMovementBonusHandler.get_handler(CONFIG.MOVEMENT_BONUS_HANDLER),
	"damage_label":$"Damage",
	"parry_area":$"ParryArea",
	"powerup_cooldown":$"UsePowerupCooldown",
	"multiplayer_sync":$"InputSynchronizer",
	"hitstun_timer": $"Hitstun",
	"animation_player": $"AnimationPlayer",
	"floor_detector":$"FloorDetector"
}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.multiplayer_sync.set_action_handler(CONFIG.ACTION_HANDLER)
	add_child(onready_paths.primary_weapon)
	add_child(onready_paths.movement_bonus)
	onready_paths.movement_bonus.player = self
	onready_paths.primary_weapon.projectile_owner = self
	onready_paths.damage_label.text = "%f" % DAMAGE

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D):

	if not _frozen:
		velocity = state.get_linear_velocity()
		var delta = state.get_step()
		
		# override the velocity if needed
		if _velocity_override != Vector2.ZERO:
			velocity = _velocity_override
			_velocity_override = Vector2.ZERO

		var is_on_floor = _is_on_floor()

		# Handle jump
		if _is_action_just_active(ActionHandlerBase.actions.JUMP) and is_on_floor:
			velocity.y = JUMP_VELOCITY
		
		# Adds the additional vector
		velocity += _additional_vector
		_additional_vector = Vector2.ZERO

		# Get the input direction and handle the movement/deceleration.
		var acceleration = FLOOR_ACCELERATION if is_on_floor else AIR_ACCELERATION
		velocity.x = move_toward(velocity.x, direction.x * TARGET_SPEED, acceleration * delta)
		

		# sets the velocity
		state.set_linear_velocity(velocity)

		# Buffer the velocity 
		_buffer_velocity(velocity)

func _physics_process(_delta):
	_handle_inputs()


##### PUBLIC METHODS #####
func hurt(p_damage : float, knockback : float, kb_direction : Vector2) -> void:
	DAMAGE += p_damage
	onready_paths.damage_label.text = "%f" % DAMAGE
	_additional_vector += kb_direction.normalized() * DAMAGE * knockback
	_start_hitstun()


func respawn() -> void:
	emit_signal("killed",player)
	queue_free()

func override_velocity(velocity_override : Vector2) -> void:
	_velocity_override += velocity_override

func stop_hitstun() -> void:
	if _hitstunned:
		onready_paths.hitstun_timer.stop()
		_on_hitstun_timeout()

func toggle_freeze(active : bool) -> void:
	set_deferred("freeze", active)
	set_deferred("sleeping", active)
	_frozen = active

##### PROTECTED METHODS #####
func _handle_inputs() -> void:
	_handle_direction_inputs()
	_handle_fire()
	_handle_movement_bonus()
	_handle_parry()
	_handle_powerup()

func _handle_direction_inputs() -> void:
	direction = Vector2.ZERO
	if _is_action_active(ActionHandlerBase.actions.LEFT):
		direction.x -= 1
	if _is_action_active(ActionHandlerBase.actions.RIGHT):
		direction.x += 1
	if _is_action_active(ActionHandlerBase.actions.UP):
		direction.y -= 1
	if _is_action_active(ActionHandlerBase.actions.DOWN):
		direction.y += 1
	onready_paths.primary_weapon.aim(direction)

func _handle_fire() -> void:
	if _is_action_just_active(ActionHandlerBase.actions.FIRE):
		onready_paths.primary_weapon.fire()

func _handle_movement_bonus() -> void:
	if onready_paths.multiplayer_sync.action_states.has(ActionHandlerBase.actions.MOVEMENT_BONUS):
		onready_paths.movement_bonus.state = onready_paths.multiplayer_sync.action_states.get(ActionHandlerBase.actions.MOVEMENT_BONUS)

func _handle_parry() -> void:
	if _is_action_just_active(ActionHandlerBase.actions.PARRY):
		onready_paths.parry_area.parry()

func _handle_powerup() -> void:
	if _is_action_just_active(ActionHandlerBase.actions.POWERUP) and _can_use_powerup:
		var powerup = StaticPowerupHandler.get_powerup(CONFIG.POWERUP_HANDLER)
		powerup.global_position = self.global_position
		get_tree().current_scene.add_child(powerup)
		_can_use_powerup = false
		onready_paths.powerup_cooldown.start()

func _is_on_floor() -> bool:
	if onready_paths.floor_detector.is_colliding():
		var collision_normal = onready_paths.floor_detector.get_collision_normal()
		return collision_normal.angle_to(Vector2.RIGHT) <= MAX_FLOOR_ANGLE or collision_normal.angle_to(Vector2.LEFT) <= MAX_FLOOR_ANGLE
	return false

# mostly to improve readability
func _is_action_active(action : ActionHandlerBase.actions) -> bool:
	if onready_paths.multiplayer_sync.action_states.has(action):
		return ActionHandlerBase.is_active(onready_paths.multiplayer_sync.action_states.get(action))
	return false

# mostly to improve readability
func _is_action_just_active(action : ActionHandlerBase.actions) -> bool:
	if onready_paths.multiplayer_sync.action_states.has(action):
		return ActionHandlerBase.is_just_active(onready_paths.multiplayer_sync.action_states.get(action))
	return false

func _start_hitstun() -> void:
	var x = min(MAX_HITSTUN_DAMAGE, DAMAGE)/MAX_HITSTUN_DAMAGE
	var time = _cubic_ease_out(x) * MAX_HITSTUN_TIME
	onready_paths.hitstun_timer.start(time)
	onready_paths.animation_player.play("hitstun")
	physics_material_override.bounce = HITSTUN_BOUNCE
	_hitstunned = true

# https://easings.net/#easeOutCubic
func _cubic_ease_out(x : float) -> float:
	return min(1.0, abs(1 - pow(1 - x, 3)))

func _buffer_velocity(vel_to_buffer : Vector2) -> void:
	velocity_buffer.pop_back()
	velocity_buffer.push_front(vel_to_buffer)

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
func _on_use_powerup_cooldown_timeout():
	_can_use_powerup = true

func _on_hitstun_timeout() -> void:
	_hitstunned = false
	physics_material_override.bounce = NORMAL_BOUNCE
	onready_paths.animation_player.stop()
	onready_paths.animation_player.play("RESET")
