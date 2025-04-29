@tool
extends HBoxContainer
# Counter player data ui type 

##### VARIABLES #####
#---- EXPORTS -----
@export var DATA_ICON : Texture : set = set_icon
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

func set_icon(icon : Texture) -> void:
	onready_paths.icon.texture = icon
	DATA_ICON = icon

func set_progress(value : float) -> void:
	onready_paths.progress.value = fmod(value,1.0)
	if(value >= 1):
		onready_paths.overflow.text = "+%d" % [value]
	else:
		onready_paths.overflow.text = ""
	PROGRESS = value
