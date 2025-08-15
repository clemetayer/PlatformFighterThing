extends CharacterBody2D
# player script

##### SIGNALS #####
signal killed(id : int)
signal movement_updated(id: int, value)
signal powerup_updated(id: int, value)
signal game_message_triggered(id : int)

##### VARIABLES #####
#---- CONSTANTS -----
const TARGET_SPEED := 1000.0 # px/s
const JUMP_VELOCITY := -1200.0
const MAX_FLOOR_ANGLE := PI/4
const NORMAL_BOUNCE := 0.05
const HITSTUN_BOUNCE := 1.0
const FLOOR_ACCELERATION := 9000.0 
const AIR_ACCELERATION := FLOOR_ACCELERATION / 2.0
const PREDICT_BOUNCE_OFFSET := 64.0
const BOUNCE_DAMPING := 0.85
const MAX_DAMAGE := 999
const MAX_BOUNCE_PREDICTIONS := 10
const WEIGHT := 2.5 # multiplier for the gravity

#---- EXPORTS -----
@export var DAMAGE := 0.0
@export var GAME_PROXY_PATH := ".."

#==== MOSTLY FOR MULTIPLAYER PURPOSES ====
@export var id := 1 :
	set(player_idx):
		id = player_idx
		# Give authority over the player input to the appropriate peer.
		$InputSynchronizer.set_multiplayer_authority(id)
@export var sync_velocity : Vector2
@export var sync_position : Vector2

#---- STANDARD -----
#==== PUBLIC ====
var direction := Vector2.ZERO 
var jump_triggered := false

#==== PRIVATE ====
var _gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity") * WEIGHT
var _frozen := false
var _velocity_override := Vector2.ZERO
var _additional_vector := Vector2.ZERO # external forces that can have an effect on the player and needs to be added to the velocity on the next physics frame
var _freeze_buffer_velocity := Vector2.ZERO
var _damage_enabled := true
var _truce_active := false # allows for players to move freely but can't shoot or use abilities. Usefull during the start countdown of the game 
var _velocity_buffer := [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO] # 3 frame buffer for the velocity. Usefull to keep track of the velocity when elements are going too fast
var _scene_utils := SceneUtils
var _runtime_utils := RuntimeUtils

#==== ONREADY ====
@onready var onready_paths_node := $"Paths"


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths_node.init.initialize(get_node(GAME_PROXY_PATH).get_player_config(id))
	_appear()
	_scene_utils.connect("toggle_scene_freeze", _on_SceneUtils_toggle_scene_freeze)
	_load_sync_physics()

func _physics_process(delta: float) -> void:
	if not _frozen:
		_load_sync_physics()

		if not _is_on_floor():
			velocity.y += _gravity * delta
		elif velocity.y > 0 and _is_on_floor(): # to bounce back on horizontal destroyable walls
			velocity.y = 0
		
		if _freeze_buffer_velocity != Vector2.ZERO:
			velocity = _freeze_buffer_velocity
			_freeze_buffer_velocity = Vector2.ZERO
		if _velocity_override != Vector2.ZERO:
			velocity = _velocity_override
			_velocity_override = Vector2.ZERO

		if jump_triggered and _is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		velocity += _additional_vector
		_additional_vector = Vector2.ZERO

		var acceleration = FLOOR_ACCELERATION if _is_on_floor() else AIR_ACCELERATION
		velocity.x = move_toward(velocity.x, direction.x * TARGET_SPEED, acceleration * delta)
		
		_predict_bounces()

		if onready_paths_node.hitstun_manager.hitstunned:
			var collision_normal = _get_collisions_normal()
			if collision_normal != Vector2.ZERO:
				velocity.bounce(collision_normal)
		
		move_and_slide()

		_buffer_velocity(velocity)

		_save_sync_physics()

##### PUBLIC METHODS #####
func hurt(p_damage : float, knockback : float, kb_direction : Vector2, p_owner : Node2D = null) -> void:
	if _damage_enabled:
		DAMAGE = min(DAMAGE + p_damage,MAX_DAMAGE)
		_additional_vector += kb_direction.normalized() * DAMAGE * knockback
		onready_paths_node.hitstun_manager.start_hitstun(DAMAGE)
		onready_paths_node.death_manager.set_last_hit_owner(p_owner)

@rpc("authority", "call_local", "reliable")
func kill() -> void:
	onready_paths_node.death_manager.kill()

@rpc("authority", "call_local", "reliable")
func override_velocity(velocity_override : Vector2) -> void:
	_velocity_override += velocity_override

@rpc("authority", "call_local", "reliable")
func toggle_freeze(active : bool) -> void:
	_freeze_buffer_velocity = velocity
	set_deferred("freeze", active)
	set_deferred("sleeping", active)
	_frozen = active

# Activates the player's abilities (fire, powerup, movement). Especially usefull waiting for the game startup screen to end 
func toggle_abilities(active : bool) -> void:
	if not _truce_active:
		onready_paths_node.primary_weapon.active = active
		onready_paths_node.movement_bonus.active = active
		onready_paths_node.powerup_manager.active = active
		onready_paths_node.parry_area.toggle_parry(active)

func toggle_damage(active : bool) -> void:
	_damage_enabled = active

func toggle_truce(active : bool) -> void:
	# Note : calls the toggle abilities twice to make sure it is updated 
	toggle_abilities(not active)
	_truce_active = active
	toggle_abilities(not active)

func get_config() -> PlayerConfig:
	return get_node(GAME_PROXY_PATH).get_player_config(id)

func get_velocity_buffer() -> Array:
	return _velocity_buffer

func get_direction() -> Vector2:
	return direction

##### PROTECTED METHODS #####
func _appear() -> void:
	toggle_freeze(true)
	toggle_abilities(false)
	toggle_damage(false)
	onready_paths_node.appear_elements.play_spawn_animation()

func _buffer_velocity(vel_to_buffer : Vector2) -> void:
	_velocity_buffer.pop_back()
	_velocity_buffer.push_front(vel_to_buffer)

func _predict_bounces() -> void:
	var travel_distance_next_frame = velocity * 1.0 / Engine.get_physics_ticks_per_second()
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, position + travel_distance_next_frame, 1)
	var intersection = space_state.intersect_ray(query)
	var predict_bounce_cnt = 0
	while intersection and predict_bounce_cnt < MAX_BOUNCE_PREDICTIONS:
		position = intersection.position + intersection.normal * PREDICT_BOUNCE_OFFSET  # slight position correction to avoid repositionning in the wall
		if intersection.collider.is_in_group("destructible_wall"): # breakable wall, should not bounce
			return
		elif not onready_paths_node.hitstun_manager.hitstunned: # if hitstunned just stopped, reset the velocity if it collides with a wall to avoid going through at high velocities
			velocity = Vector2.ZERO 
			return 
		else:
			var distance_traveled = global_position - intersection.position
			velocity = velocity.bounce(intersection.normal) * BOUNCE_DAMPING
			if travel_distance_next_frame.length() - distance_traveled.length() <= 0:
				return
			travel_distance_next_frame = velocity.normalized() * (travel_distance_next_frame - distance_traveled).length()
			query = PhysicsRayQueryParameters2D.create(position, position + travel_distance_next_frame, 1)
			intersection = space_state.intersect_ray(query)
		predict_bounce_cnt += 1

func _save_sync_physics() -> void:
	if _runtime_utils.is_authority():
		sync_velocity = velocity
		sync_position = global_position

func _load_sync_physics() -> void:
	if not _runtime_utils.is_authority():
		velocity = sync_velocity
		global_position = sync_position

func _get_collisions_normal() -> Vector2:
	var collision_normal_sum = Vector2.ZERO
	for col_idx in get_slide_collision_count():
		collision_normal_sum = get_slide_collision(col_idx).get_normal()
	if collision_normal_sum == Vector2.ZERO:
		return collision_normal_sum
	return (collision_normal_sum / get_slide_collision_count()).normalized()

# mostly for test purposes because _process is really important to test here
func _is_on_floor() -> bool:
	return is_on_floor()

##### SIGNAL MANAGEMENT #####
func _on_SceneUtils_toggle_scene_freeze(value: bool) -> void:
	toggle_freeze(value)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == onready_paths_node.appear_elements.APPEAR_ANIM_NAME:
		toggle_freeze(false)
		toggle_abilities(true)
		toggle_damage(true)
