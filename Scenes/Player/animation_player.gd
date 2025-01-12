extends AnimationPlayer

##### PUBLIC METHODS #####
@rpc("call_local","authority","unreliable")
func remote_play_animation(animation : String) -> void:
	stop()
	play(animation)
