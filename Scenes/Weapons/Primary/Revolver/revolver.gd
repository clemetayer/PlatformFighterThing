extends PrimaryWeaponBase
# Basic revolver

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
	"sprite": $"Sprite2D",
	"gunshot": $"Gunshot"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_set_los_init_modulate()

##### PUBLIC METHODS #####
@rpc("authority","call_local","reliable")
func fire() -> void:
	if not _on_cooldown and active:
		_fire_anim()
		_play_gunshot()
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

func _fire_anim() -> void:
	if _fire_anim_tween:
		_fire_anim_tween.kill() # Abort the previous animation.
	_fire_anim_tween = create_tween()
	onready_paths.line_of_sight.modulate = Color.WHITE
	onready_paths.line_of_sight.width = FIRE_ANIM_MAX_WIDTH
	_fire_anim_tween.tween_property(onready_paths.line_of_sight,"modulate",owner_color,FIRE_ANIM_TIME)
	_fire_anim_tween.tween_property(onready_paths.line_of_sight,"width",LOS_DEFAULT_WIDTH,FIRE_ANIM_TIME)

func _play_gunshot() -> void:
	onready_paths.gunshot.play()

func _set_los_init_modulate() -> void:
	onready_paths.line_of_sight.modulate = owner_color

##### SIGNAL MANAGEMENT #####
func _on_shoot_cooldown_timeout():
	_on_cooldown = false
