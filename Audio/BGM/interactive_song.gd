extends AudioStreamPlayer
# Utilitary script to work with AudioStreamInteractive

##### PUBLIC METHODS #####
func switch_to_clip_by_name(name : String) -> void:
	get_stream_playback().switch_to_clip_by_name(name)
