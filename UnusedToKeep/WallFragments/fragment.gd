extends RigidBody2D
# fragment of a destructible wall for the wall break effect

##### VARIABLES #####
#---- CONSTANTS -----
const FORCE_MULTIPLIER := 10000.0

#---- STANDARD -----
#==== PRIVATE ====
var _original_position : Vector2
var _original_rotation : float
var _impulse := Vector2.ZERO

#==== ONREADY ====
@onready var onready_paths := {
	"collision": $"CollisionPolygon2D"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.collision.disabled = true
	_original_position = position
	_original_rotation = rotation

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if _impulse != Vector2.ZERO and not freeze:
		apply_central_impulse(_impulse)
		_impulse = Vector2.ZERO

##### PUBLIC METHODS #####
func explode(p_position : Vector2, force : Vector2) -> void:
	onready_paths.collision.disabled = false
	set_deferred("freeze",false)
	_impulse = force * 1/(abs(global_position - p_position) * 20.0) * FORCE_MULTIPLIER

func reset() -> void:
	onready_paths.collision.disabled = true
	set_deferred("freeze",true)
	position = _original_position
	rotation = _original_rotation
