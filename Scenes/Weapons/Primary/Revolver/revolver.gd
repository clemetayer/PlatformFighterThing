extends PrimaryWeaponBase
# Basic revolver

##### SIGNALS #####

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const PROJECTILE_SCENE_PATH := "res://Scenes/Weapons/Projectiles/bullet.tscn"
const ANGLE_STEP := PI/4

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
var projectile_owner = null # the owner of the projectile that will spawn, i.e : the player with the weapon

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
	pass

##### PUBLIC METHODS #####
func fire() -> void:
	if not _on_cooldown:
		_spawn_projectile(_create_projectile())
		_on_cooldown = true
		onready_paths.shoot_cooldown_timer.start()

func aim(relative_aim_position : Vector2) -> void:
	var analog_angle = Vector2.ZERO.angle_to_point(relative_aim_position)
	rotation = _get_closest_angle(analog_angle, ANGLE_STEP)

##### PROTECTED METHODS #####
func _get_closest_angle(analog_angle : float, angle_step : float) -> float:
	return round(analog_angle/angle_step) * angle_step

func _create_projectile() -> Node:
	var projectile = load(PROJECTILE_SCENE_PATH).instantiate()
	projectile.current_owner = projectile_owner
	projectile.global_position = global_position
	projectile.rotation = rotation
	return projectile

##### SIGNAL MANAGEMENT #####
func _on_shoot_cooldown_timeout():
	_on_cooldown = false
