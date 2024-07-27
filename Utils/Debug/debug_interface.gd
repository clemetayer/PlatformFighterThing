extends CanvasLayer
# A debug interface

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant = 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _active := false
var _properties := {}

#==== ONREADY ====
@onready var onready_paths := {
	"label": $"Control/Label"
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
	if Input.is_action_just_pressed("toggle_debug_interface"):
		_active = !_active
	visible = _active
	if _active:
		onready_paths.label.text = _stringify_properties()
	_properties = {}

##### PUBLIC METHODS #####
func set_debug_text(property : String, value) -> void:
	_properties[property] = value

##### PROTECTED METHODS #####
func _stringify_properties() -> String:
	var str = ""
	for key in _properties.keys():
		str += "%s: %s\n" % [key, _properties[key]]
	return str

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received

