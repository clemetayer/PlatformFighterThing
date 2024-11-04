extends MovementBonusBase
# Simple dash as a movement bonus
# FIXME : by shooting, then dashing, then parrying, you can parry your own bullet, but this can be a feature, it is kind of cool

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const DASH_FORCE := 1800
const MAX_DASHES := 3

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _dashes_available := MAX_DASHES

#==== ONREADY ====
@onready var onready_paths := {
	"reload_timer":$"ReloadDashTimer",
	"dash_particles":$"DashParticles"
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
	if ActionHandlerBase.is_just_active(state) and _dashes_available > 0:
		player.override_velocity(player.direction.normalized() * DASH_FORCE)
		_dashes_available -= 1
		rpc("_emit_particles", Vector3(-player.direction.normalized().x, -player.direction.normalized().y,0), -player.direction.normalized().angle())
		if onready_paths.reload_timer.is_stopped():
			onready_paths.reload_timer.start()

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

##### PROTECTED METHODS #####
func _print_dashes_available() -> void:
	print("dashes available = %d" % _dashes_available)

@rpc("call_local","authority","unreliable")
func _emit_particles(particle_direction : Vector3, particle_angle : float) -> void:
	onready_paths.dash_particles.process_material.angle_min = rad_to_deg(particle_angle)
	onready_paths.dash_particles.process_material.angle_max = rad_to_deg(particle_angle)
	onready_paths.dash_particles.process_material.direction = particle_direction
	onready_paths.dash_particles.emitting = true

##### SIGNAL MANAGEMENT #####
func _on_reload_dash_timer_timeout():
	_dashes_available += 1
	if _dashes_available < MAX_DASHES:
		onready_paths.reload_timer.start()
