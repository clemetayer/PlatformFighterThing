extends PrimaryWeaponBase
# Basic revolver

##### SIGNALS #####

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const PROJECTILE_SCENE_PATH := "res://Scenes/Weapons/Projectiles/bullet.tscn"
const LOS_DEFAULT_WIDTH := 2
const FIRE_ANIM_MAX_WIDTH := 20
const FIRE_ANIM_TIME := 0.2

#---- EXPORTS -----
@export var owner_color := Color.WHITE

#---- STANDARD -----
#==== PUBLIC ====
var projectile_owner = null # the owner of the projectile that will spawn, i.e : the player with the weapon

#==== PRIVATE ====
var _on_cooldown := false
var _fire_anim_tween : Tween

#==== ONREADY ====
@onready var onready_paths := {
	"line_of_sight": $"Line2D",
	"shoot_cooldown_timer": $"ShootCooldown",
	"sprite": $"Sprite2D"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_los_init_modulate()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

func _physics_process(_delta):
	pass

##### PUBLIC METHODS #####
func fire() -> void:
	if not _on_cooldown:
		rpc("_fire_anim")
		_spawn_projectile(_create_projectile())
		_on_cooldown = true
		onready_paths.shoot_cooldown_timer.start()

func aim(relative_aim_position : Vector2) -> void:
	var analog_angle = Vector2.ZERO.angle_to_point(relative_aim_position)
	rotation = analog_angle
	if abs(rotation) >= PI/2.0:
		onready_paths.sprite.scale.y = abs(onready_paths.sprite.scale.y) * -1
	else:
		onready_paths.sprite.scale.y = abs(onready_paths.sprite.scale.y)
	

##### PROTECTED METHODS #####
func _create_projectile() -> Node:
	var projectile = load(PROJECTILE_SCENE_PATH).instantiate()
	projectile.current_owner = projectile_owner
	projectile.global_position = global_position
	projectile.rotation = rotation
	projectile.trail_color = owner_color
	return projectile

@rpc("call_local","authority","unreliable")
func _fire_anim() -> void:
	if _fire_anim_tween:
		_fire_anim_tween.kill() # Abort the previous animation.
	_fire_anim_tween = create_tween()
	onready_paths.line_of_sight.modulate = Color.WHITE
	onready_paths.line_of_sight.width = FIRE_ANIM_MAX_WIDTH
	_fire_anim_tween.tween_property(onready_paths.line_of_sight,"modulate",owner_color,FIRE_ANIM_TIME)
	_fire_anim_tween.tween_property(onready_paths.line_of_sight,"width",LOS_DEFAULT_WIDTH,FIRE_ANIM_TIME)

func _set_los_init_modulate() -> void:
	onready_paths.line_of_sight.modulate = owner_color

##### SIGNAL MANAGEMENT #####
func _on_shoot_cooldown_timeout():
	_on_cooldown = false
