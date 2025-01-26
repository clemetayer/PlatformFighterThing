extends Node2D
# triangle city background management 

# TODO : Make the whole thing scroll and scale correctly depending on the camera
# TODO : fix the piano and drone 2 trigger timing not being quite right
# TODO : Add something for when the chorus hits (instead of the pluck string that is a bit too much in the background)
# TODO : Same with arpeggios
# TODO : Same with lead

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

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
		"background": $"BackLayer/Background/BackgroundAnims",
		"back_buildings": $"BackLayer/BackBuildings/BackBuildingsAnims",
		"glow": $"MidLayer/GlowAnims",
		"spotlights_mid": $"MidLayer/ParallaxBackground/SpotLightAnims",
		"front_buildings": $"FrontLayer/ParallaxBackground/FrontBuildingsAnims",
		"spotlights_front": $"FrontLayer/SpotlightsAnims",
		"flashing_front": $"FrontLayer/FlashingFrontAnims",
		"triangle_group": [
			$"Multiple/FlashingTriangles/TriangleGroup1", 
			$"Multiple/FlashingTriangles/TriangleGroup2", 
			$"Multiple/FlashingTriangles/TriangleGroup3"
		]
	}
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
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

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
	pass # Replace with function body.


func _on_fitting_title_o_hat() -> void:
	onready_paths.animation.spotlights_front.play("flash")


func _on_fitting_title_piano() -> void:
	onready_paths.animation.triangle_group[_piano_cnt].play("flash")
	_piano_cnt = (_piano_cnt + 1) % 3


func _on_fitting_title_pluck_string() -> void:
	pass # Replace with function body.


func _on_fitting_title_snare() -> void:
	onready_paths.animation.background.play("flash")
