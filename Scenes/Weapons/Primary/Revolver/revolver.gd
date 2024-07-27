extends Node2D
# Basic revolver

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const PROJECTILE_SCENE_PATH := "res://Scenes/Weapons/Primary/Projectiles/bullet.tscn"

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _on_cooldown := false

#==== ONREADY ====
@onready var onready_paths := {
	"shoot_cooldown_timer": $"ShootCooldown"
}

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

func _physics_process(_delta):
	_handle_inputs()

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
func _handle_inputs() -> void:
	_handle_directions()
	_handle_fire()

func _handle_directions() -> void:
	if Input.is_action_pressed("up"):
		rotation = -PI/2
	elif Input.is_action_pressed("down"):
		rotation = PI/2
	elif Input.is_action_pressed("left"):
		rotation = PI
	elif Input.is_action_pressed("right"):
		rotation = 0

func _handle_fire() -> void:
	if Input.is_action_just_pressed("fire") and not _on_cooldown:
		_spawn_projectile()
		_on_cooldown = true
		onready_paths.shoot_cooldown_timer.start()

func _spawn_projectile() -> void:
	var projectile = load(PROJECTILE_SCENE_PATH).instantiate()
	projectile.global_position = global_position
	projectile.rotation = rotation
	get_tree().current_scene.add_child(projectile)

##### SIGNAL MANAGEMENT #####
func _on_shoot_cooldown_timeout():
	_on_cooldown = false
