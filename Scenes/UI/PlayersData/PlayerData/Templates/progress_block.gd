@tool
extends HBoxContainer
# Counter player data ui type 

##### VARIABLES #####
#---- EXPORTS -----
@export var DATA_ICON : String : set = set_icon
@export var PROGRESS : float : set = set_progress

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"icon":$"Icon",
	"overflow":$"Overflow",
	"progress":$"ProgressBar"
}

##### PUBLIC METHODS #####
func set_value(value) -> void:
	set_progress(float(value))

@rpc("authority","call_local","reliable")
func set_icon(icon_path : String) -> void:
	onready_paths.icon.texture = load(icon_path)
	DATA_ICON = icon_path

func set_progress(value : float) -> void:
	onready_paths.progress.value = fmod(value,1.0)
	if(value >= 1):
		onready_paths.overflow.text = "+%d" % [value]
	else:
		onready_paths.overflow.text = ""
	PROGRESS = value
