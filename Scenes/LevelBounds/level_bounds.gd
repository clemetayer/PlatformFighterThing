extends Area2D
# level bounds script

##### VARIABLES #####
#---- CONSTANTS -----
const CAMERA_DEATH_IMPACT_TIME := 1 #s

##### SIGNAL MANAGEMENT #####
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		CameraEffects.emit_signal_start_camera_impact(CAMERA_DEATH_IMPACT_TIME,CameraEffects.CAMERA_IMPACT_INTENSITY.HIGH, CameraEffects.CAMERA_IMPACT_PRIORITY.HIGH)
		body.respawn()
