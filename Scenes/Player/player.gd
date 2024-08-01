extends CharacterBody2D
# docstring

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const TARGET_SPEED = 500.0 # px/s
const JUMP_VELOCITY = -600.0

#---- EXPORTS -----
@export var ACTION_HANDLER : StaticActionHandlerStrategy.handlers
@export var PRIMARY_WEAPON : StaticPrimaryWeaponHandler.weapons

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _direction := Vector2.ZERO

#==== ONREADY ====
@onready var onready_paths := {
	"action_handler":StaticActionHandlerStrategy.get_handler(ACTION_HANDLER),
	"primary_weapon":StaticPrimaryWeaponHandler.get_weapon(PRIMARY_WEAPON)
}
@onready var FLOOR_ACCELERATION = 50.0 * ProjectSettings.get_setting("physics/common/physics_ticks_per_second") # px/s² # Kind of a constant, that's why it is in all caps
@onready var AIR_ACCELERATION = 25.0 * ProjectSettings.get_setting("physics/common/physics_ticks_per_second") # px/s² # Kind of a constant, that's why it is in all caps


##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(onready_paths.action_handler)
	add_child(onready_paths.primary_weapon)

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
	if ActionHandlerBase.is_just_active(onready_paths.action_handler.jump) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var acceleration = FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x, _direction.x * TARGET_SPEED, acceleration * delta)
	move_and_slide()

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _handle_inputs() -> void:
	_handle_direction_inputs()
	_handle_fire()

func _handle_direction_inputs() -> void:
	_direction = Vector2.ZERO
	if ActionHandlerBase.is_active(onready_paths.action_handler.left):
		_direction.x -= 1
	if ActionHandlerBase.is_active(onready_paths.action_handler.right):
		_direction.x += 1
	if ActionHandlerBase.is_active(onready_paths.action_handler.up):
		_direction.y -= 1
	if ActionHandlerBase.is_active(onready_paths.action_handler.down):
		_direction.y += 1
	onready_paths.primary_weapon.aim(_direction)

func _handle_fire() -> void:
	if ActionHandlerBase.is_just_active(onready_paths.action_handler.fire):
		onready_paths.primary_weapon.fire()

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
