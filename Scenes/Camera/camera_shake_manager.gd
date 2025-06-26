extends Node
# Handles the camera shakes and tilts

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _tilt_tween : Tween

#==== ONREADY ====
@onready var root := get_parent()
@onready var shaker := get_node("../Shaker")

##### PUBLIC METHODS #####
func start_camera_shake(duration : float, intensity : CameraEffects.CAMERA_IMPACT_INTENSITY) -> void:
	if shaker.is_playing:
		shaker.force_stop_shake()
	shaker.set_duration(duration)
	var shake_preset
	match intensity:
		CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT:
			shake_preset = RuntimeConfig.camera_effects_intensity_preset.SHAKE_LOW
		CameraEffects.CAMERA_IMPACT_INTENSITY.MEDIUM:
			shake_preset = RuntimeConfig.camera_effects_intensity_preset.SHAKE_MID
		CameraEffects.CAMERA_IMPACT_INTENSITY.HIGH:
			shake_preset = RuntimeConfig.camera_effects_intensity_preset.SHAKE_HIGH
	shaker.set_shaker_preset(shake_preset)
	shaker.play_shake()

func start_camera_tilt(duration : float, intensity : CameraEffects.CAMERA_IMPACT_INTENSITY) -> void:
	var rot_angle = [1,-1].pick_random()
	var duration_divider = 1.0
	match intensity:
		CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT:
			rot_angle *= RuntimeConfig.camera_effects_intensity_preset.LOW_TILT_ROTATION_ANGLE
			duration_divider = RuntimeConfig.camera_effects_intensity_preset.LOW_TILT_DURATION_DIVIDER
		CameraEffects.CAMERA_IMPACT_INTENSITY.MEDIUM:
			rot_angle *= RuntimeConfig.camera_effects_intensity_preset.MID_TILT_ROTATION_ANGLE
			duration_divider = RuntimeConfig.camera_effects_intensity_preset.MID_TILT_DURATION_DIVIDER
		CameraEffects.CAMERA_IMPACT_INTENSITY.HIGH:
			rot_angle *= RuntimeConfig.camera_effects_intensity_preset.HIGH_TILT_ROTATION_ANGLE
			duration_divider = RuntimeConfig.camera_effects_intensity_preset.HIGH_TILT_DURATION_DIVIDER
	_tilt_camera(rot_angle, duration, duration_divider)

##### PROTECTED METHODS #####
func _tilt_camera(angle : float, duration : float, duration_divider : float) -> void:
	if _tilt_tween:
		_tilt_tween.kill() # Abort the previous animation.
	_tilt_tween = create_tween()
	_tilt_tween.tween_method(root.set_rotation, 0.0, angle, duration / duration_divider)
	await _tilt_tween.finished
	_tilt_tween.kill() # Abort the previous animation.
	_tilt_tween = create_tween()
	root.rotation = angle
	_tilt_tween.tween_method(root.set_rotation, angle, 0.0, duration - duration / duration_divider)
	await _tilt_tween.finished
	root.rotation = 0.0
