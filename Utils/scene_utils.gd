extends Node
# Utility script to manipulate the scene globally

##### SIGNALS #####
signal toggle_scene_freeze(value : bool)

##### PUBLIC METHODS #####
func freeze_scene_parry(time : float):
	emit_signal("toggle_scene_freeze", true)
	await get_tree().create_timer(time).timeout
	emit_signal("toggle_scene_freeze", false)
