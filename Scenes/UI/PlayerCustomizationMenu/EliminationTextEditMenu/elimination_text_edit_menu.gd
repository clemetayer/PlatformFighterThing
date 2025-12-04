extends MarginContainer
# menu to edit the elimination text for a player

##### SIGNALS #####
signal elimination_text_updated(new_text: String)

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"text": $"VBoxContainer/VBoxContainer/LineEdit"
}


##### PUBLIC METHODS #####
func get_elimination_text() -> String:
	return onready_paths.text.text

func set_elimination_text(text: String) -> void:
	onready_paths.text.text = text

##### SIGNAL MANAGEMENT #####
func _on_line_edit_text_changed(new_text: String) -> void:
	emit_signal("elimination_text_updated", new_text)
