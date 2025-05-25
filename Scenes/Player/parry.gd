extends Area2D
# script for the parry system

##### SIGNALS #####
signal parried

#---- STANDARD -----
#==== PRIVATE ====
var _parrying := false
var _can_parry := true
var _enabled := true

#==== ONREADY ====
@onready var _owner := get_parent()
@onready var onready_paths_node := $"../Paths"
@onready var onready_paths := {
	"animation_player": $"ParryAnimations",
	"parry_timer":$"ParryTimer",
	"lockout_timer":$"LockoutTimer"
}

##### PUBLIC METHODS #####
func toggle_parry(active : bool) -> void:
	_enabled = active 

func parry() -> void:
	if _enabled:
		if _can_parry:
			_parrying = true
			monitoring = true
			onready_paths.parry_timer.start()
			onready_paths.animation_player.remote_play_animation("parrying")
			onready_paths_node.parry_active_sound.play()
		else:
			onready_paths_node.parry_wrong.play()

##### SIGNAL MANAGEMENT #####
func _on_area_entered(area):
	if area.is_in_group("projectile") and _parrying:
		onready_paths.animation_player.remote_play_animation("parried")
		onready_paths_node.parry_sound.play()
		onready_paths.parry_timer.stop()
		_can_parry = true
		_parrying = false
		set_deferred("monitoring", false)
		area.parried(_owner, onready_paths_node.input_synchronizer.relative_aim_position)
		CameraEffects.emit_signal_start_camera_impact(0.25, CameraEffects.CAMERA_IMPACT_INTENSITY.LIGHT, CameraEffects.CAMERA_IMPACT_PRIORITY.MEDIUM)
		SceneUtils.freeze_scene_parry(0.25)
		emit_signal("parried")

func _on_lockout_timer_timeout():
	_can_parry = true

func _on_parry_timer_timeout():
	onready_paths.animation_player.remote_play_animation("parry_lockout")
	_can_parry = false
	_parrying = false
	monitoring = false
	onready_paths.lockout_timer.start()
