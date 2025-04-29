extends Control
# Controls and displays the time left of the match (and potentially some other funny things)

##### SIGNALS #####
signal time_over

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const END_TEXT := "[wave amp=50.0 freq=5.0 connected=1]END[/wave]"

#---- EXPORTS -----
# @export var EXPORT_NAME := 10.0 # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _start_time
var _end_time

#==== ONREADY ====
@onready var onready_paths := {
	"label": $"Label"
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
	if _start_time != null and _end_time != null:
		var current_time = Time.get_ticks_msec()
		if current_time >= _end_time:
			_time_over()
		else:
			_refresh_timer(current_time)

##### PUBLIC METHODS #####
# starts the timer for a specific duration (in seconds)
func start_timer(duration : int) -> void:
	_start_time = Time.get_ticks_msec()
	_end_time = _start_time + duration * 1000.0

##### PROTECTED METHODS #####
func _time_over() -> void:
	onready_paths.label.text = END_TEXT
	_start_time = null
	_end_time = null
	emit_signal("time_over")

func _refresh_timer(current_time : int) -> void:
	var time = int((current_time -  _start_time)/1000)
	var seconds = time % 60
	var minutes = int(time / 60.0)
	onready_paths.label.text = "%02d:%02d" % [minutes,seconds]

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
