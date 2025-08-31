@tool
extends HBoxContainer
# Handles the buttons to run the tests in the ui

##### SIGNALS #####
signal run_all
signal run_specific_test

##### SIGNAL MANAGEMENT #####v
func _on_run_all_pressed() -> void:
	emit_signal("run_all")


func _on_run_specific_test_pressed() -> void:
	emit_signal("run_specific_test")
