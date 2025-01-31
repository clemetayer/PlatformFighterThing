extends Node
# Fitting title script

##### SIGNALS #####
signal kick
signal drone_1
signal drone_2
signal o_hat
signal c_hat
signal snare
signal pluck_string
signal arpeggio
signal piano
signal lead
signal drone_1_octave_up

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
@export var KICK_ACTIVE : bool = false
@export var DRONE_1_ACTIVE : bool = false
@export var DRONE_2_ACTIVE : bool = false
@export var O_HAT_ACTIVE : bool = false
@export var C_HAT_ACTIVE : bool = false
@export var SNARE_ACTIVE : bool = false
@export var PLUCK_STRING_ACTIVE : bool = false
@export var ARPEGGIO_ACTIVE : bool = false
@export var PIANO_ACTIVE : bool = false
@export var LEAD_ACTIVE : bool = false
@export var DRONE_1_OCTAVE_UP_ACTIVE : bool = false

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _beat_count := 0

#==== ONREADY ====
@onready var onready_paths := {
	"rythm":$"RhythmNotifier",
	"animation":$"AnimationPlayer",
	"song": $"Song"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_connect_rythm_notifier()
	onready_paths.song.play()
	onready_paths.animation.play("Intro")
	onready_paths.rythm.running = true

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _connect_rythm_notifier() -> void:
	onready_paths.rythm.beat.connect(_beat)
	onready_paths.rythm.beats(1.0/2.0).connect(_half_beat)
	onready_paths.rythm.beats(1.0/4.0).connect(_quarter_beat)
	onready_paths.rythm.beats(1.0/3.0).connect(_triplet_beat)

func _beat(count) -> void:
	if KICK_ACTIVE:
		emit_signal("kick")
	if C_HAT_ACTIVE:
		emit_signal("c_hat")
	if LEAD_ACTIVE:
		_lead(count)
	if DRONE_1_OCTAVE_UP_ACTIVE:
		emit_signal("drone_1_octave_up")

func _half_beat(count) -> void:
	if DRONE_1_ACTIVE:
		emit_signal("drone_1")
	if O_HAT_ACTIVE:
		if count % 2 == 1:
			emit_signal("o_hat")
	if SNARE_ACTIVE:
		_snare(count)

func _quarter_beat(count) -> void:
	if ARPEGGIO_ACTIVE:
		emit_signal("arpeggio")
	if DRONE_2_ACTIVE:
		_drone_2(count)

func _triplet_beat(count) -> void:
	if PIANO_ACTIVE:
		emit_signal("piano")

func _snare(count) -> void:
	if count % 4 == 2: # most of the bar
		emit_signal("snare")
	elif count % 32  == 28:
		emit_signal("snare")
	elif count % 32 == 31:
		emit_signal("snare")

func _drone_2(count) -> void:
	if count % 32 == 14: # the last part of the bar
		emit_signal("drone_2")
	elif count % 3 == 0 and count % 16 != 15: # most of the bar
		emit_signal("drone_2")

func _lead(count) -> void:
	var lead_time_notes = [0,4,7,8,12,16,19,20,22,24,28,31] # there is an offset compared to the lmms file
	if count % 32 in lead_time_notes:
		emit_signal("lead")

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
