extends MovementBonusBase
# Simple dash as a movement bonus

##### VARIABLES #####
#---- CONSTANTS -----
const DASH_VELOCITY := Vector2(2500,1700)
const MAX_DASHES := 3

#---- EXPORTS -----
@export var DASHES_AVAILABLE := MAX_DASHES

#---- STANDARD -----
#==== PRIVATE ====
var _init_ui_done := false # just to update the UI once on the first frame

#==== ONREADY ====
@onready var onready_paths := {
	"reload_timer":$"ReloadDashTimer",
	"dash_particles":$"DashParticles",
	"sound":$"DashSound"
}

##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if not _init_ui_done:
		emit_signal("value_updated",DASHES_AVAILABLE)
		_init_ui_done = true

##### PROTECTED METHODS #####
func _emit_particles() -> void:
	if onready_paths.dash_particles.emitting:
		onready_paths.dash_particles.restart()
	onready_paths.dash_particles.emitting = true

func _play_sound() -> void:
	onready_paths.sound.play()
 
##### PUBLIC METHODS #####
@rpc("authority", "call_local", "reliable")
func activate() -> void:
	if DASHES_AVAILABLE > 0 and active:
		player.override_velocity(player.get_direction().normalized() * DASH_VELOCITY)
		DASHES_AVAILABLE -= 1
		emit_signal("value_updated",DASHES_AVAILABLE)
		_emit_particles()
		_play_sound()
		if onready_paths.reload_timer.is_stopped():
			onready_paths.reload_timer.start()

##### SIGNAL MANAGEMENT #####
func _on_reload_dash_timer_timeout():
	DASHES_AVAILABLE += 1
	emit_signal("value_updated",DASHES_AVAILABLE)
	if DASHES_AVAILABLE < MAX_DASHES:
		onready_paths.reload_timer.start()
