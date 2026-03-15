@tool
extends ConditionLeaf

# randomly returns success or failure and change the return value after the defined time

##### VARIABLES #####
#---- EXPORTS -----
@export var SUCCESS_CHANCE := 0.5
@export var DELAY_TIME := 1.0

#---- STANDARD -----
#==== PRIVATE ====
var _is_success := false

#==== ONREADY ====
@onready var timer := $"Timer"
@onready var rng := RandomNumberGenerator.new()


##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_refresh_success_value()
	timer.set_wait_time(DELAY_TIME)


func tick(_actor: Node, _blackboard: Blackboard) -> int:
	return SUCCESS if _is_success else FAILURE


##### PROTECTED METHODS #####
func _refresh_success_value() -> void:
	_is_success = rng.randf() <= SUCCESS_CHANCE


##### SIGNAL MANAGEMENT #####
func _on_timer_timeout() -> void:
	_refresh_success_value()
