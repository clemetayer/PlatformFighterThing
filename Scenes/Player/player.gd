extends CharacterBody2D
# docstring

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _direction := Vector2.ZERO

#==== ONREADY ====
# onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	if _direction.x:
		velocity.x = _direction.x * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _handle_inputs() -> void:
	_handle_direction_inputs()

func _handle_direction_inputs() -> void:
	if Input.is_action_pressed("left"):
		_direction.x -= 1
	if Input.is_action_pressed("right"):
		_direction.x += 1
	if Input.is_action_pressed("up"):
		_direction.y -= 1
	if Input.is_action_pressed("down"):
		_direction.y += 1

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
