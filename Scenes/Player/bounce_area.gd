extends Area2D
# mostly to trigger a camera shake on bounce

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var collision_shape := $"CollisionShape2D"

##### PUBLIC METHODS #####
func toggle_active(active: bool) -> void:
	set_deferred("monitoring", active)
	set_deferred("monitorable", active)
	collision_shape.set_deferred("disabled", !active)

##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node2D) -> void:
	CameraEffects.emit_signal_start_camera_impact(0.07,CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT,CameraEffects.CAMERA_IMPACT_PRIORITY.LOW)
