extends CharacterBody2D
# player script

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const TARGET_SPEED := 500.0 # px/s
const JUMP_VELOCITY := -600.0
const MAX_HITSTUN_TIME := 3 # s
const MAX_HITSTUN_DAMAGE := 999 # damage points

#---- EXPORTS -----
@export var ACTION_HANDLER : StaticActionHandlerStrategy.handlers
@export var PRIMARY_WEAPON : StaticPrimaryWeaponHandler.weapons
@export var MOVEMENT_BONUS_HANDLER : StaticMovementBonusHandler.handlers
@export var POWERUP_HANDLER : StaticPowerupHandler.handlers
@export var DAMAGE := 0.0
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$InputSynchronizer.set_multiplayer_authority(id)

#---- STANDARD -----
#==== PUBLIC ====
var direction := Vector2.ZERO

#==== PRIVATE ====
var _gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _additional_vector := Vector2.ZERO # external forces that can have an effect on the player and needs to be added to the velocity on the next physics frame
var _can_use_powerup := true
var _velocity_buffer := [Vector2.ZERO,Vector2.ZERO,Vector2.ZERO] # 3 frames velocity buffer for the bounce effect, workaround to avoid the collision reset when colliding
var _hitstunned := false

#==== ONREADY ====
@onready var FLOOR_ACCELERATION = 50.0 * ProjectSettings.get_setting("physics/common/physics_ticks_per_second") # px/s² # Kind of a constant, that's why it is in all caps
@onready var AIR_ACCELERATION = 25.0 * ProjectSettings.get_setting("physics/common/physics_ticks_per_second") # px/s² # Kind of a constant, that's why it is in all caps
@onready var onready_paths := {
	"primary_weapon":StaticPrimaryWeaponHandler.get_weapon(PRIMARY_WEAPON),
	"movement_bonus":StaticMovementBonusHandler.get_handler(MOVEMENT_BONUS_HANDLER),
	"damage_label":$"Damage",
	"parry_area":$"ParryArea",
	"powerup_cooldown":$"UsePowerupCooldown",
	"multiplayer_sync":$"InputSynchronizer",
	"hitstun_timer": $"Hitstun",
	"animation_player": $"AnimationPlayer"
}


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.multiplayer_sync.set_action_handler(ACTION_HANDLER)
	add_child(onready_paths.primary_weapon)
	add_child(onready_paths.movement_bonus)
	onready_paths.movement_bonus.player = self
	onready_paths.primary_weapon.projectile_owner = self
	onready_paths.damage_label.text = "%f" % DAMAGE

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

func _physics_process(delta):
	_handle_inputs()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += _gravity * delta
	else:
		velocity.y = 0

	# Handle jump.
	if _is_action_just_active(ActionHandlerBase.actions.JUMP) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var acceleration = FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x, direction.x * TARGET_SPEED, acceleration * delta)

	# Adds the additional vector
	velocity += _additional_vector
	_additional_vector = Vector2.ZERO
	
	# Store the previous velocity
	# Note : might create a bug since this does not save the "real" velocity, 
	#        but allows the additionnal vector to not be discarded when bouncing on obstacles
	_buffer_velocity()

	# Bounce back on obstacles
	if _hitstunned:
		_bounce_on_obstacles()

	# Move
	move_and_slide()



##### PUBLIC METHODS #####
func hurt(p_damage : float, knockback : float, kb_direction : Vector2) -> void:
	DAMAGE += p_damage
	onready_paths.damage_label.text = "%f" % DAMAGE
	_additional_vector += kb_direction.normalized() * DAMAGE * knockback
	_start_hitstun()

func bounce_back(bounce_direction : Vector2) -> void:
	if bounce_direction.x != 0:
		velocity.x = bounce_direction.x
	elif bounce_direction.y != 0:
		velocity.y = bounce_direction.y

func respawn() -> void:
	global_position = Vector2.ZERO
	velocity = Vector2.ZERO
	DAMAGE = 0
	onready_paths.damage_label.text = "%f" % DAMAGE

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
		var powerup = StaticPowerupHandler.get_powerup(POWERUP_HANDLER)
		powerup.global_position = self.global_position
		get_tree().current_scene.add_child(powerup)
		_can_use_powerup = false
		onready_paths.powerup_cooldown.start()

func _bounce_on_obstacles() -> void:
	var obs_normal = _get_average_collision_normal()
	if obs_normal != Vector2.ZERO:
		velocity = _velocity_buffer[1].bounce(obs_normal)

func _get_average_collision_normal() -> Vector2:
	var collision_count = get_slide_collision_count()
	if collision_count == 0 :
		return Vector2.ZERO
	var normal_sum = Vector2.ZERO
	for col_idx in collision_count:
		normal_sum += get_slide_collision(col_idx).get_normal()
	return (normal_sum / collision_count).normalized()

func _buffer_velocity() -> void:
	_velocity_buffer.pop_back()
	_velocity_buffer.push_front(velocity)

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
	_hitstunned = true

# https://easings.net/#easeOutCubic
func _cubic_ease_out(x : float) -> float:
	return min(1.0, abs(1 - pow(1 - x, 3)))

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
func _on_use_powerup_cooldown_timeout():
	_can_use_powerup = true


func _on_hitstun_timeout() -> void:
	_hitstunned = false
	onready_paths.animation_player.stop()
	onready_paths.animation_player.play("RESET")
