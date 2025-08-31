@tool
extends HBoxContainer
# Handles the inputs filename

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"filename": $"LineEdit"
}

##### PROTECTED METHODS #####
func set_inputs_filename(filename : String) -> void:
	onready_paths.filename.text = filename

func get_inputs_filename() -> String:
	return onready_paths.filename.text
