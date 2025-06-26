extends Node
# Handles the camera effects
##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _full_screen_effects := FullScreenEffects

##### PUBLIC METHODS #####
func start_chromatic_aberration(duration : float, intensity : CameraEffects.CAMERA_IMPACT_INTENSITY) -> void:
	var strength = 0.0
	var duration_divider = 1.0
	match intensity:
		CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT:
			strength = RuntimeConfig.camera_effects_intensity_preset.LOW_CHROMATIC_ABERRATION_STRENGTH
			duration_divider = RuntimeConfig.camera_effects_intensity_preset.LOW_CHROMATIC_ABERRATION_DURATION_DIVIDER
		CameraEffects.CAMERA_IMPACT_INTENSITY.MEDIUM:
			strength = RuntimeConfig.camera_effects_intensity_preset.MID_CHROMATIC_ABERRATION_STRENGTH
			duration_divider = RuntimeConfig.camera_effects_intensity_preset.MID_CHROMATIC_ABERRATION_DURATION_DIVIDER
		CameraEffects.CAMERA_IMPACT_INTENSITY.HIGH:
			strength = RuntimeConfig.camera_effects_intensity_preset.HIGH_CHROMATIC_ABERRATION_STRENGTH
			duration_divider = RuntimeConfig.camera_effects_intensity_preset.HIGH_CHROMATIC_ABERRATION_DURATION_DIVIDER
	_full_screen_effects.chromatic_aberration(strength, duration, duration_divider)
