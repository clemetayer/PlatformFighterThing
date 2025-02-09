extends GridContainer
# to test the signals of fitting_title

##### VARIABLES #####
#---- EXPORTS -----
@export var ROOT_PATH : NodePath = ".."
@export var TEST_MODE : bool = false

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = TEST_MODE
	if TEST_MODE:
		_connect_signals()

##### PROTECTED METHODS #####
func _connect_signals() -> void:
	var root = get_node(ROOT_PATH)
	root.connect("kick",_on_fitting_title_kick)
	root.connect("drone_1",_on_fitting_title_drone_1)
	root.connect("drone_2",_on_fitting_title_drone_2)
	root.connect("o_hat",_on_fitting_title_o_hat)
	root.connect("c_hat",_on_fitting_title_c_hat)
	root.connect("snare",_on_fitting_title_snare)
	root.connect("pluck_string",_on_fitting_title_pluck_string)
	root.connect("arpeggio",_on_fitting_title_arpeggio)
	root.connect("piano",_on_fitting_title_piano)
	root.connect("lead",_on_fitting_title_lead)

##### SIGNAL MANAGEMENT #####
func _on_fitting_title_kick() -> void:
	$Kick.text = "kick"
	await get_tree().create_timer(0.25).timeout
	$Kick.text = ""


func _on_fitting_title_drone_1() -> void:
	$Drone1.text = "drone 1"
	await get_tree().create_timer(0.075).timeout
	$Drone1.text = ""


func _on_fitting_title_o_hat() -> void:
	$OHat.text = "open hat"
	await get_tree().create_timer(0.25).timeout
	$OHat.text = ""


func _on_fitting_title_c_hat() -> void:
	$CHat.text = "closed hat"
	await get_tree().create_timer(0.25).timeout
	$CHat.text = ""


func _on_fitting_title_snare() -> void:
	$Snare.text = "snare"
	await get_tree().create_timer(0.075).timeout
	$Snare.text = ""


func _on_fitting_title_pluck_string() -> void:
	$PluckString.text = "pluck string"
	await get_tree().create_timer(0.075).timeout
	$PluckString.text = ""


func _on_fitting_title_arpeggio() -> void:
	$Arpeggio.text = "arpeggio"
	await get_tree().create_timer(0.05).timeout
	$Arpeggio.text = ""


func _on_fitting_title_drone_2() -> void:
	$Drone2.text = "drone_2"
	await get_tree().create_timer(0.075).timeout
	$Drone2.text = ""


func _on_fitting_title_piano() -> void:
	$Piano.text = "piano"
	await get_tree().create_timer(0.05).timeout
	$Piano.text = ""


func _on_fitting_title_lead() -> void:
	$Lead.text = "lead"
	await get_tree().create_timer(0.3).timeout
	$Lead.text = ""
