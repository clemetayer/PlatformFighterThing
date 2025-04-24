extends MovementBonusBase
# Simple dash as a movement bonus
# FIXME : by shooting, then dashing, then parrying, you can parry your own bullet, but this can be a feature, it is kind of cool

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const DASH_VELOCITY := Vector2(2500,1700)
const MAX_DASHES := 3

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====

#==== PRIVATE ====
var _dashes_available := MAX_DASHES
var _init_ui_done := false # just to update the UI once on the first frame

#==== ONREADY ====
@onready var onready_paths := {
	"reload_timer":$"ReloadDashTimer",
	"dash_particles":$"DashParticles",
	"sound":$"DashSound"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if not _init_ui_done:
		emit_signal("value_updated",_dashes_available)
		_init_ui_done = true
	if ActionHandlerBase.is_just_active(state) and _dashes_available > 0:
		player.override_velocity(player.direction.normalized() * DASH_VELOCITY)
		_dashes_available -= 1
		emit_signal("value_updated",_dashes_available)
		rpc("_emit_particles") # TODO : RPCs not really usefull here ? To test.
		rpc("_play_sound")
		if onready_paths.reload_timer.is_stopped():
			onready_paths.reload_timer.start()

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
func _print_dashes_available() -> void:
	Logger.debug("dashes available = %d" % _dashes_available)

@rpc("call_local","authority","unreliable")
func _emit_particles() -> void:
	if onready_paths.dash_particles.emitting:
		onready_paths.dash_particles.restart()
	onready_paths.dash_particles.emitting = true

@rpc("call_local","authority","unreliable")
func _play_sound() -> void:
	onready_paths.sound.play()
 
##### SIGNAL MANAGEMENT #####
func _on_reload_dash_timer_timeout():
	_dashes_available += 1
	emit_signal("value_updated",_dashes_available)
	if _dashes_available < MAX_DASHES:
		onready_paths.reload_timer.start()
