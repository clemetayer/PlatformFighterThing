extends Node
# Controls the full screen effects shaders

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _chromatic_aberration_tween : Tween

#==== ONREADY ====
@onready var onready_paths := {
	"layers": {
		"front": $"FrontLayer",
		"back": $"BackLayer"
	},
	"chromatic_aberration": $"FrontLayer/ChromaticAberrationBuffer/ChromaticAberration",
	"monochrome": $"BackLayer/MonochromeBuffer/Monochrome",
	"pincushion": $"FrontLayer/PinCushionBuffer/PinCushion"
}

##### PUBLIC METHODS #####
func toggle_active(active : bool) -> void:
	for layer_key in onready_paths.layers.keys():
		onready_paths.layers[layer_key].visible = active

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

func monochrome(duration : float) -> void:
	onready_paths.monochrome.get_material().set_shader_parameter("ACTIVE", true)
	await get_tree().create_timer(duration).timeout
	onready_paths.monochrome.get_material().set_shader_parameter("ACTIVE", false)

func pincushion(duration : float) -> void:
	onready_paths.pincushion.play_animation(duration)
