extends Area2D
# mostly to trigger a camera shake on bounce

##### VARIABLES #####
#---- CONSTANTS -----
const CAMERA_IMPACT_TIME := 0.07 #s

#---- STANDARD -----
#==== PRIVATE ====
var _camera_effects := CameraEffects
#==== ONREADY ====
@onready var collision_shape := $"CollisionShape2D"

##### PUBLIC METHODS #####
func toggle_active(active: bool) -> void:
	set_deferred("monitoring", active)
	set_deferred("monitorable", active)
	collision_shape.set_deferred("disabled", !active)

##### SIGNAL MANAGEMENT #####
func _on_body_entered(_body: Node2D) -> void:
	_camera_effects.emit_signal_start_camera_impact(CAMERA_IMPACT_TIME,CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT,CameraEffects.CAMERA_IMPACT_PRIORITY.LOW)
