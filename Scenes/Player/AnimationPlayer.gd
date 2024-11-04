extends AnimationPlayer

##### PUBLIC METHODS #####
@rpc("call_local","authority","unreliable")
func remote_play_animation(animation : String) -> void:
	stop()
	play(animation)

##### PROTECTED METHODS #####
func _on_parry_area_parried():
	pass # TODO : remove that or make a better animation
