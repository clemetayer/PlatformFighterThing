extends Camera2D
# Camera script

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const ZOOM_OFFSET := Vector2i.ONE * 100
const ZOOM_BASE_MULTIPLIER := 0.5 # change this to correct the zoom or dezoom
const ZOOM_DAMPING := 1.0 # to keep the game relatively clear and avoid too harsh camera movements

#---- EXPORTS -----
@export var PLAYERS_ROOT_PATH : NodePath = "../Players"

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _current_impact_priority := CameraEffects.CAMERA_IMPACT_PRIORITY.NONE
var _tilt_tween : Tween
var _zoom_tween : Tween
var _zoom_multiplier := ZOOM_BASE_MULTIPLIER


#==== ONREADY ====
@onready var onready_paths := {
	"shaker": $"Shaker",
	"full_screen_effects": $"FullScreenEffects"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	CameraEffects.connect("start_camera_impact",_on_start_camera_impact)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	global_position = _get_average_position()
	var best_zoom = _get_best_zoom()
	if best_zoom > 0 :
		zoom = zoom.move_toward(Vector2.ONE * best_zoom * _zoom_multiplier,delta * ZOOM_DAMPING)

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
func _get_average_position() -> Vector2:
	var sum = Vector2.ZERO
	if get_node_or_null(PLAYERS_ROOT_PATH) != null:
		var players = get_node(PLAYERS_ROOT_PATH).get_children()
		for player in players:
			sum += player.global_position
		return sum / players.size()
	return Vector2.ZERO # should never go here

func _get_best_zoom() -> float:
	var min_max_pos = _get_global_min_max_pos()
	var min_pos = min_max_pos.min
	var max_pos = min_max_pos.max
	var screen_size_offset = DisplayServer.screen_get_size() - ZOOM_OFFSET
	var best_zoom := Vector2.ZERO
	best_zoom.x = max(abs(min_pos.x - max_pos.x)/(screen_size_offset.x/2),1)
	best_zoom.y = max(abs(min_pos.y - max_pos.y)/(screen_size_offset.y/2),1)
	return 1/max(best_zoom.x, best_zoom.y)

func _get_global_min_max_pos() -> Dictionary:
	var min_pos := Vector2.INF
	var max_pos := Vector2.ZERO
	if get_node_or_null(PLAYERS_ROOT_PATH) != null: 
		var players = get_node(PLAYERS_ROOT_PATH).get_children()
		for player in players:
			if player.global_position.x < min_pos.x:
				min_pos.x = player.global_position.x
			if player.global_position.y < min_pos.y:
				min_pos.y = player.global_position.y
			if player.global_position.x > max_pos.x:
				max_pos.x = player.global_position.x
			if player.global_position.y > max_pos.y:
				max_pos.y = player.global_position.y
	return {
		"min": min_pos,
		"max": max_pos
	}

@rpc("call_local", "authority", "unreliable")
func _start_camera_impact(duration : float, intensity : CameraEffects.CAMERA_IMPACT_INTENSITY, priority: CameraEffects.CAMERA_IMPACT_PRIORITY) -> void:
	if priority >= _current_impact_priority:
		_current_impact_priority = priority
		_start_camera_shake(duration, intensity)
		_start_camera_tilt(duration, intensity)
		_start_fast_zoom(duration, intensity)
		_start_chromatic_aberration(duration, intensity)
		
func _start_camera_shake(duration : float, intensity : CameraEffects.CAMERA_IMPACT_INTENSITY) -> void:
	if onready_paths.shaker.is_playing:
		onready_paths.shaker.force_stop_shake()
	onready_paths.shaker.set_duration(duration)
	var shake_preset
	match intensity:
		CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT:
			shake_preset = RuntimeConfig.camera_effects_intensity_preset.SHAKE_LOW
		CameraEffects.CAMERA_IMPACT_INTENSITY.MEDIUM:
			shake_preset = RuntimeConfig.camera_effects_intensity_preset.SHAKE_MID
		CameraEffects.CAMERA_IMPACT_INTENSITY.HIGH:
			shake_preset = RuntimeConfig.camera_effects_intensity_preset.SHAKE_HIGH
	onready_paths.shaker.set_shaker_preset(shake_preset)
	onready_paths.shaker.play_shake()
	

func _start_camera_tilt(duration : float, intensity : CameraEffects.CAMERA_IMPACT_INTENSITY) -> void:
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

func _tilt_camera(angle : float, duration : float, duration_divider : float) -> void:
	if _tilt_tween:
		_tilt_tween.kill() # Abort the previous animation.
	_tilt_tween = create_tween()
	rotation = 0.0
	_tilt_tween.tween_property(self,"rotation",angle,duration / duration_divider)
	await _tilt_tween.finished
	_tilt_tween.stop()
	_tilt_tween.tween_property(self,"rotation",0.0, duration - duration / duration_divider)
	_tilt_tween.play()
	await _tilt_tween.finished
	rotation = 0.0

func _start_fast_zoom(duration : float, intensity : CameraEffects.CAMERA_IMPACT_INTENSITY) -> void:
	var final_zoom_val = ZOOM_BASE_MULTIPLIER
	var duration_divider = 1.0
	match intensity:
		CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT:
			final_zoom_val = ZOOM_BASE_MULTIPLIER * RuntimeConfig.camera_effects_intensity_preset.LOW_FINAL_ZOOM_MULTIPLIER
			duration_divider = RuntimeConfig.camera_effects_intensity_preset.LOW_ZOOM_DURATION_DIVIDER
		CameraEffects.CAMERA_IMPACT_INTENSITY.MEDIUM:
			final_zoom_val = ZOOM_BASE_MULTIPLIER * RuntimeConfig.camera_effects_intensity_preset.MID_FINAL_ZOOM_MULTIPLIER
			duration_divider = RuntimeConfig.camera_effects_intensity_preset.MID_ZOOM_DURATION_DIVIDER
		CameraEffects.CAMERA_IMPACT_INTENSITY.HIGH:
			final_zoom_val = ZOOM_BASE_MULTIPLIER * RuntimeConfig.camera_effects_intensity_preset.HIGH_FINAL_ZOOM_MULTIPLIER
			duration_divider = RuntimeConfig.camera_effects_intensity_preset.HIGH_ZOOM_DURATION_DIVIDER
	_fast_zoom(final_zoom_val, duration, duration_divider)

func _fast_zoom(final_zoom_amount : float, duration : float, duration_divider : float) -> void:
	if _zoom_tween:
		_zoom_tween.kill() # Abort the previous animation.
	_zoom_tween = create_tween()
	_zoom_multiplier = ZOOM_BASE_MULTIPLIER
	_zoom_tween.tween_property(self,"_zoom_multiplier",final_zoom_amount,duration / duration_divider)
	await _zoom_tween.finished
	_zoom_tween.stop()
	_zoom_tween.tween_property(self,"_zoom_multiplier",ZOOM_BASE_MULTIPLIER, duration - duration / duration_divider)
	_zoom_tween.play()
	await _zoom_tween.finished
	_zoom_multiplier = ZOOM_BASE_MULTIPLIER

func _start_chromatic_aberration(duration : float, intensity : CameraEffects.CAMERA_IMPACT_INTENSITY) -> void:
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
	onready_paths.full_screen_effects.chromatic_aberration(strength, duration, duration_divider)

##### SIGNAL MANAGEMENT #####
func _on_start_camera_impact(duration : float, intensity : CameraEffects.CAMERA_IMPACT_INTENSITY, priority: CameraEffects.CAMERA_IMPACT_PRIORITY) -> void:
	if RuntimeUtils.is_authority():
		rpc("_start_camera_impact", duration, intensity, priority)

func _on_shaker_shake_finished() -> void:
	_current_impact_priority = CameraEffects.CAMERA_IMPACT_PRIORITY.NONE
