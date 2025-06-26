extends Camera2D
# Camera script

##### VARIABLES #####
#---- EXPORTS -----
@export var PLAYERS_ROOT_PATH : NodePath = "../Players"

#---- STANDARD -----
#==== PRIVATE ====
var _current_impact_priority := CameraEffects.CAMERA_IMPACT_PRIORITY.NONE
var _focus_on = null


#==== ONREADY ====
@onready var onready_paths := {
	"shaker": $"Shaker",
	"position_manager": $"CameraPositionManager",
	"zoom_manager": $"CameraZoomManager",
	"shake_manager": $"CameraShakeManager",
	"effect_manager": $"CameraEffectsManager",
	"focus_on_timer": $"FocusOnTimer"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	CameraEffects.connect("start_camera_impact",_on_start_camera_impact)
	CameraEffects.connect("focus_on", _on_focus_on)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	if _focus_on != null:
		global_position = global_position.move_toward(_focus_on.position, delta * _focus_on.time_to_focus * 600)
		zoom = zoom.move_toward(Vector2.ONE * _focus_on.zoom, delta * _focus_on.time_to_focus)
	else:
		global_position = onready_paths.position_manager.get_average_position(get_node(PLAYERS_ROOT_PATH).get_children())
		var best_zoom = onready_paths.zoom_manager.get_best_zoom(get_node(PLAYERS_ROOT_PATH).get_children())
		if best_zoom > 0 :
			zoom = zoom.move_toward(
				Vector2.ONE * best_zoom * onready_paths.zoom_manager.zoom_multiplier, 
				delta * onready_paths.zoom_manager.get_zoom_damping()
			)

##### PROTECTED METHODS #####
func _start_camera_impact(duration : float, intensity : CameraEffects.CAMERA_IMPACT_INTENSITY, priority: CameraEffects.CAMERA_IMPACT_PRIORITY) -> void:
	if priority >= _current_impact_priority:
		_current_impact_priority = priority
		onready_paths.shake_manager.start_camera_shake(duration, intensity)
		onready_paths.shake_manager.start_camera_tilt(duration, intensity)
		onready_paths.zoom_manager.start_fast_zoom(duration, intensity)
		onready_paths.effect_manager.start_chromatic_aberration(duration, intensity)

##### SIGNAL MANAGEMENT #####
func _on_start_camera_impact(duration : float, intensity : CameraEffects.CAMERA_IMPACT_INTENSITY, priority: CameraEffects.CAMERA_IMPACT_PRIORITY) -> void:
	_start_camera_impact(duration, intensity, priority)

func _on_focus_on(p_position : Vector2, p_zoom : float, p_time_to_focus : float, duration : float) -> void:
	_focus_on = {
		"position": p_position,
		"zoom": p_zoom,
		"time_to_focus": p_time_to_focus
	}
	onready_paths.focus_on_timer.start(duration)

func _on_shaker_shake_finished() -> void:
	_current_impact_priority = CameraEffects.CAMERA_IMPACT_PRIORITY.NONE

func _on_focus_on_timer_timeout() -> void:
	_focus_on = null
