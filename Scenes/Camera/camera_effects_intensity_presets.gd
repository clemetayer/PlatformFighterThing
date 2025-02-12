extends Resource
class_name CameraEffectsIntensityPresets
# Resource to configure the camera effects intensity depending on the player preference

##### VARIABLES #####
#---- EXPORTS -----
@export_group("CAMERA_SHAKE")
@export var SHAKE_HIGH : ShakerPreset2D
@export var SHAKE_MID : ShakerPreset2D
@export var SHAKE_LOW : ShakerPreset2D

@export_group("CAMERA_TILT")
@export var LOW_TILT_ROTATION_ANGLE : float
@export var LOW_TILT_DURATION_DIVIDER := 1.0
@export var MID_TILT_ROTATION_ANGLE : float
@export var MID_TILT_DURATION_DIVIDER := 1.0
@export var HIGH_TILT_ROTATION_ANGLE : float
@export var HIGH_TILT_DURATION_DIVIDER := 1.0

@export_group("CAMERA_ZOOM")
@export var LOW_FINAL_ZOOM_MULTIPLIER := 1.0
@export var LOW_ZOOM_DURATION_DIVIDER := 1.0
@export var MID_FINAL_ZOOM_MULTIPLIER := 1.0
@export var MID_ZOOM_DURATION_DIVIDER := 1.0
@export var HIGH_FINAL_ZOOM_MULTIPLIER := 1.0
@export var HIGH_ZOOM_DURATION_DIVIDER := 1.0
