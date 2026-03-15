extends CanvasLayer

# A debug interface

##### VARIABLES #####
#---- CONSTANTS -----
const POSITION_INDICATOR_SCENE := preload("res://Utils/Debug/position_indicator.tscn")

#---- STANDARD -----
#==== PRIVATE ====
var _active := false
var _properties := { }
var _input := Input
var _position_indicators := { }

#==== ONREADY ====
@onready var onready_paths := {
	"label": $"Control/Label",
}


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if _input.is_action_just_pressed("toggle_debug_interface"):
		_active = !_active
	visible = _active
	if _active:
		onready_paths.label.text = _stringify_properties()
	_properties = { }


##### PUBLIC METHODS #####
func set_debug_text(property: String, value) -> void:
	_properties[property] = value


func set_debug_position(id: String, position: Vector2, color: Color) -> void:
	if _position_indicators.has(id):
		_position_indicators[id].global_position = position
		_position_indicators[id].modulate = color
		_position_indicators[id].visible = _active
		return
	var position_indicator = POSITION_INDICATOR_SCENE.instantiate()
	position_indicator.modulate = color
	_position_indicators[id] = position_indicator
	get_tree().get_root().add_child(position_indicator)
	position_indicator.global_position = position
	position_indicator.visible = _active


##### PROTECTED METHODS #####
func _stringify_properties() -> String:
	var ret_str = ""
	for key in _properties.keys():
		ret_str += "%s: %s\n" % [key, _properties[key]]
	return ret_str


func _on_clear_position_indicators_timeout() -> void:
	for key in _position_indicators.keys():
		_position_indicators[key].queue_free()
		_position_indicators.erase(key)
