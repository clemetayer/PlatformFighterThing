@tool
extends HBoxContainer
# Handles the button to record inputs for an integration test

##### SIGNALS #####
signal record_inputs

##### SIGNAL MANAGEMENT #####
func _on_record_pressed() -> void:
	emit_signal("record_inputs")
