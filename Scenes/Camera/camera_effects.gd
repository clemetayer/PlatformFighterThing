extends Node
# Singleton to trigger various camera effects

##### SIGNALS #####
signal start_camera_impact(duration : float, intensity : CAMERA_IMPACT_INTENSITY, priority : CAMERA_IMPACT_PRIORITY)
signal focus_on(position : Vector2, zoom : float, time_to_focus : float, duration : float)

##### ENUMS #####
enum CAMERA_IMPACT_INTENSITY {LIGHT, MEDIUM, HIGH}
enum CAMERA_IMPACT_PRIORITY {NONE, LOW, MEDIUM, HIGH}

##### PUBLIC METHODS #####
func emit_signal_start_camera_impact(duration : float, intensity : CAMERA_IMPACT_INTENSITY, priority : CAMERA_IMPACT_PRIORITY = CAMERA_IMPACT_PRIORITY.LOW) -> void:
	emit_signal("start_camera_impact", duration, intensity, priority)

func emit_signal_focus_on(position : Vector2, zoom : float, time_to_focus : float, duration : float) -> void:
	emit_signal("focus_on",position, zoom, time_to_focus, duration)