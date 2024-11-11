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
const MAX_FLOOR_ANGLE := PI/4
const NORMAL_BOUNCE := 0.05
const HITSTUN_BOUNCE := 1.0

#---- EXPORTS -----
@export var CONFIG : PlayerConfig
@export var DAMAGE := 0.0
#==== MOSTLY FOR MULTIPLAYER PURPOSES ====
@export var id := 1 :
	set(player_idx):
		id = player_idx
		# Give authority over the player input to the appropriate peer.
		$InputSynchronizer.set_multiplayer_authority(id)

#---- STANDARD -----
#==== PUBLIC ====
var velocity := Vector2.ZERO
var direction := Vector2.ZERO
var jump_triggered := false
var velocity_buffer := [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO] # 3 frame buffer for the velocity. Usefull to keep track of the velocity when elements are going too fast

#==== PRIVATE ====
var _frozen := false
var _velocity_override := Vector2.ZERO
var _additional_vector := Vector2.ZERO # external forces that can have an effect on the player and needs to be added to the velocity on the next physics frame

#==== ONREADY ====
@onready var FLOOR_ACCELERATION = 100.0 * ProjectSettings.get_setting("physics/common/physics_ticks_per_second") # px/s² # Kind of a constant, that's why it is in all caps
@onready var AIR_ACCELERATION = 50.0 * ProjectSettings.get_setting("physics/common/physics_ticks_per_second") # px/s² # Kind of a constant, that's why it is in all caps
@onready var onready_paths_node := $"Paths"


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths_node.init.initialize(CONFIG)
	SceneUtils.connect("toggle_scene_freeze", _on_SceneUtils_toggle_scene_freeze)

func _integrate_forces(state: PhysicsDirectBodyState2D):
	if not _frozen and RuntimeUtils.is_authority():
		velocity = state.get_linear_velocity()
		var delta = state.get_step()
		
		# override the velocity if needed
		if _velocity_override != Vector2.ZERO:
			velocity = _velocity_override
			_velocity_override = Vector2.ZERO

		var is_on_floor = _is_on_floor()

		# Handle jump
		if jump_triggered and is_on_floor:
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

##### PUBLIC METHODS #####
func hurt(p_damage : float, knockback : float, kb_direction : Vector2) -> void:
	DAMAGE += p_damage
	onready_paths_node.damage_label.text = "%f" % DAMAGE
	_additional_vector += kb_direction.normalized() * DAMAGE * knockback
	onready_paths_node.hitstun_manager.start_hitstun(DAMAGE)

func toggle_hitstun_bounce(active : bool) -> void:
	physics_material_override.bounce = HITSTUN_BOUNCE if active else NORMAL_BOUNCE

func respawn() -> void:
	emit_signal("killed",id)
	queue_free()

func override_velocity(velocity_override : Vector2) -> void:
	_velocity_override += velocity_override

func toggle_freeze(active : bool) -> void:
	set_deferred("freeze", active)
	set_deferred("sleeping", active)
	_frozen = active

##### PROTECTED METHODS #####
func _is_on_floor() -> bool:
	if onready_paths_node.floor_detector.is_colliding():
		var collision_normal = onready_paths_node.floor_detector.get_collision_normal()
		return collision_normal.angle_to(Vector2.RIGHT) <= MAX_FLOOR_ANGLE or collision_normal.angle_to(Vector2.LEFT) <= MAX_FLOOR_ANGLE
	return false

func _buffer_velocity(vel_to_buffer : Vector2) -> void:
	velocity_buffer.pop_back()
	velocity_buffer.push_front(vel_to_buffer)

##### SIGNAL MANAGEMENT #####
func _on_SceneUtils_toggle_scene_freeze(value: bool) -> void:
	toggle_freeze(value)
