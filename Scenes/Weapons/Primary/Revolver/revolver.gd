extends PrimaryWeaponBase
# Basic revolver

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const PROJECTILE_SCENE_PATH := "res://Scenes/Weapons/Projectiles/bullet.tscn"

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
		_spawn_projectile()
		_on_cooldown = true
		onready_paths.shoot_cooldown_timer.start()

func aim(direction : Vector2) -> void:
	if direction.y == -1:
		rotation = -PI/2
	elif direction.y == 1:
		rotation = PI/2
	elif direction.x == -1:
		rotation = PI
	elif direction.x == 1:
		rotation = 0

##### PROTECTED METHODS #####
func _spawn_projectile() -> void:
	var projectile = load(PROJECTILE_SCENE_PATH).instantiate()
	projectile.current_owner = projectile_owner
	projectile.global_position = global_position
	projectile.rotation = rotation
	get_tree().current_scene.add_child(projectile)

##### SIGNAL MANAGEMENT #####
func _on_shoot_cooldown_timeout():
	_on_cooldown = false
