extends Node2D
# triangle city background management 
# TODO : fix the piano and drone 2 trigger timing not being quite right
# TODO : Put the level elements in a Canvas layer
# TODO : Add an option to mute the music on the game options selection
# TODO : Add options for the background intensity in the game options selection

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const SCROLL_SPEED = 500

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _piano_cnt := 0

#==== ONREADY ====
@onready var onready_paths := {
	"animation": {
		"background": $"BackLayer/Static/Background/BackgroundAnims",
		"back_buildings": $"BackLayer/BackBuildingsAnims",
		"glow": $"MidLayer/Static/GlowAnims",
		"spotlights_mid": $"MidLayer/Static/SpotlightsAnims",
		"front_buildings": $"FrontLayer/FrontBuildingsAnims",
		"spotlights_front": $"FrontLayer/Static/SpotLightsAnims",
		"flashing_front": $"ForegroundLayer/Static/FlashingFrontAnim",
		"saw_wave": $"MidLayer/Static/SawWave/SawWaveAnims",
		"triangle_group": [
			$"TriangleGroup1", 
			$"TriangleGroup2", 
			$"TriangleGroup3"
		]
	},
	"standalone": {
		"saw_wave":$"MidLayer/Static/SawWave"
	},
	"layers": {
		"back":$"BackLayer",
		"mid":$"MidLayer",
		"front":$"FrontLayer"
	},
	"particles": {
		"arpeggios":$"BackLayer/Static/ArpeggiosParticles",
		"lead":$"MidLayer/Static/Lead"
	},
	"song": $"FittingTitle"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_parallax_ignore_camera(onready_paths.layers.back)
	_parallax_ignore_camera(onready_paths.layers.mid)
	_parallax_ignore_camera(onready_paths.layers.front)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	onready_paths.layers.back.scroll_base_offset.x = onready_paths.layers.back.scroll_base_offset.x - SCROLL_SPEED * delta
	onready_paths.layers.mid.scroll_base_offset.x = onready_paths.layers.mid.scroll_base_offset.x - SCROLL_SPEED * delta
	onready_paths.layers.front.scroll_base_offset.x = onready_paths.layers.front.scroll_base_offset.x - SCROLL_SPEED * delta
	_handle_arpeggios()
	_handle_drone_1_octave_up()

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _handle_arpeggios() -> void:
	onready_paths.particles.arpeggios.emitting = onready_paths.song.ARPEGGIO_ACTIVE

func _handle_drone_1_octave_up() -> void:
	onready_paths.standalone.saw_wave.visible = onready_paths.song.DRONE_1_OCTAVE_UP_ACTIVE

func _parallax_ignore_camera(parallax : ParallaxBackground) -> void:
	for group in parallax.get_groups():
		if group.begins_with("__cameras"):
			parallax.remove_from_group(group)

##### SIGNAL MANAGEMENT #####
func _on_fitting_title_arpeggio() -> void:
	pass


func _on_fitting_title_c_hat() -> void:
	onready_paths.animation.spotlights_mid.play("flash")


func _on_fitting_title_drone_1() -> void:
	onready_paths.animation.back_buildings.play("flash")
	onready_paths.animation.front_buildings.play("flash")


func _on_fitting_title_drone_2() -> void:
	onready_paths.animation.flashing_front.play("flash")


func _on_fitting_title_kick() -> void:
	onready_paths.animation.glow.play("grow")


func _on_fitting_title_lead() -> void:
	onready_paths.particles.lead.spawn_sprite()


func _on_fitting_title_o_hat() -> void:
	onready_paths.animation.spotlights_front.play("flash")


func _on_fitting_title_piano() -> void:
	onready_paths.animation.triangle_group[_piano_cnt].play("flash")
	_piano_cnt = (_piano_cnt + 1) % 3


func _on_fitting_title_pluck_string() -> void:
	pass # Replace with function body.


func _on_fitting_title_snare() -> void:
	onready_paths.animation.background.play("flash")


func _on_fitting_title_drone_1_octave_up() -> void:
	onready_paths.animation.saw_wave.play("fade_in")
