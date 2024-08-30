extends Area2D
# destructible wall script

##### VARIABLES #####
#---- CONSTANTS -----
const AREA_COLLISION_OFFSET := 50 # px
const WALL_COLOR_GRADIENT_RES_PATH := "res://Scenes/DestructibleWalls/wall_color_gradient.tres"

#---- EXPORTS -----
@export var BASE_HEALTH := 5000 
@export var BOUNCE_BACK_FORCE := 1200
@export var BOUNCE_BACK_DIRECTION := Vector2.RIGHT

#---- STANDARD -----
#==== PRIVATE ====
var _health = BASE_HEALTH

#==== ONREADY ====
@onready var _wall_gradient := load(WALL_COLOR_GRADIENT_RES_PATH)
@onready var onready_paths := {
	"texture":$"Texture",
	"respawn_timer": $"RespawnTimer"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_toggle_activated(true)
	_update_texture_color()

##### PROTECTED METHODS #####
func _remove_health_by_velocity(velocity: Vector2) -> void:
	if BOUNCE_BACK_DIRECTION.x != 0:
		_health -= abs(velocity.x)
	elif BOUNCE_BACK_DIRECTION.y != 0:
		_health -= abs(velocity.y)
	_update_texture_color()

func _update_texture_color() -> void:
	if is_instance_valid(onready_paths.texture):
		var health_ratio =(BASE_HEALTH - _health)/BASE_HEALTH
		onready_paths.texture.color = _wall_gradient.sample(health_ratio)

func _toggle_activated(active : bool) -> void:
	visible = active
	monitoring = active
	monitorable = active

##### SIGNAL MANAGEMENT #####
func _on_body_entered(body):
	if body.is_in_group("player"):
		_remove_health_by_velocity(body.velocity)
		if _health <= 0:
			_toggle_activated(false)
			onready_paths.respawn_timer.start()
		else:
			if body.has_method("bounce_back"):
				body.bounce_back(BOUNCE_BACK_DIRECTION * BOUNCE_BACK_FORCE)

func _on_area_entered(area):
	if area.is_in_group("projectile"):
		area.queue_free()

func _on_respawn_timer_timeout() -> void:
	_health = BASE_HEALTH
	_update_texture_color()
	_toggle_activated(true)
