extends CanvasLayer
# Controls the full screen effects shaders

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _chromatic_aberration_tween : Tween

#==== ONREADY ====
@onready var onready_paths := {
	"chromatic_aberration": $"ChromaticAberration"
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
	pass

##### PUBLIC METHODS #####
func chromatic_aberration(strength : float, duration : float, duration_divider : float) -> void:
	if _chromatic_aberration_tween:
		_chromatic_aberration_tween.kill() # Abort the previous animation.
	_chromatic_aberration_tween = create_tween()
	_chromatic_aberration_tween.tween_method(func(value) : onready_paths.chromatic_aberration.material.set_shader_parameter("strength",value), 0.0, strength, duration / duration_divider)
	await _chromatic_aberration_tween.finished
	_chromatic_aberration_tween.stop()
	_chromatic_aberration_tween.tween_method(func(value) : onready_paths.chromatic_aberration.material.set_shader_parameter("strength",value),strength,0.0,duration - duration / duration_divider)
	_chromatic_aberration_tween.play()
	await _chromatic_aberration_tween.finished
	onready_paths.chromatic_aberration.material.set_shader_parameter("strength",0.0)

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
