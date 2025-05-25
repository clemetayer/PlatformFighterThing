extends AnimationPlayer

##### PUBLIC METHODS #####
func remote_play_animation(animation : String) -> void:
	stop()
	play(animation)
