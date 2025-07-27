extends Node2D

##### SIGNALS #####
signal kill_called

##### PUBLIC METHODS #####
@rpc("any_peer","reliable","call_local")
func kill() -> void:
	emit_signal("kill_called")

