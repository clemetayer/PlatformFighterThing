extends Node

##### SIGNALS #####
signal use_called

##### PUBLIC METHODS #####
@rpc("any_peer","reliable","call_local")
func use() -> void:
	emit_signal("use_called")
