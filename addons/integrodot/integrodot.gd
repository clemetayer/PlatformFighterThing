@tool
extends EditorPlugin

var _bottom_panel = null

func _enter_tree() -> void:
	_bottom_panel = preload('res://addons/integrodot/ui/bottom_panel.tscn').instantiate()

	var button = add_control_to_bottom_panel(_bottom_panel, 'Integrodot')
	button.shortcut_in_tooltip = true


func _exit_tree() -> void:
	remove_control_from_bottom_panel(_bottom_panel)
	_bottom_panel.free()
