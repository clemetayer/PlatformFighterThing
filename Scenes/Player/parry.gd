extends Area2D
# script for the parry system

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


#==== PRIVATE ====
var _parrying := false
var _can_parry := true

#==== ONREADY ====
@onready var _owner := get_parent()
@onready var onready_paths := {
	"parry_timer":$"ParryTimer",
	"lockout_timer":$"LockoutTimer"
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
	DebugInterface.set_debug_text("parrying",_parrying)
	DebugInterface.set_debug_text("can parry", _can_parry)

##### PUBLIC METHODS #####
func parry() -> void:
	if _can_parry:
		_parrying = true
		monitoring = true
		onready_paths.parry_timer.start()

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
func _on_area_entered(area):
	if area.is_in_group("hitbox") and _parrying:
		onready_paths.parry_timer.stop()
		_can_parry = true
		_parrying = false
		monitoring = false
		area.parried(_owner)

func _on_lockout_timer_timeout():
	_can_parry = true

func _on_parry_timer_timeout():
	_can_parry = false
	_parrying = false
	monitoring = false
	onready_paths.lockout_timer.start()