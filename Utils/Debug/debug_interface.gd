extends CanvasLayer
# A debug interface

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====
var _active := false
var _properties := {}
var _input := Input

#==== ONREADY ====
@onready var onready_paths := {
	"label": $"Control/Label"
}

##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if _input.is_action_just_pressed("toggle_debug_interface"):
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
	var ret_str = ""
	for key in _properties.keys():
		ret_str += "%s: %s\n" % [key, _properties[key]]
	return ret_str
