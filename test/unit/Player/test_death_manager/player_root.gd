extends Node2D

##### SIGNALS #####
signal killed(id: int)
signal game_message_triggered(id : int)
signal toggle_freeze_called(value: bool)
signal set_collision_layer_called(value)
signal set_collision_mask_called(value)
signal toggle_truce_called(value)

##### VARIABLES #####
#---- VARIABLES -----
var id : int

##### PUBLIC METHODS #####
@rpc("any_peer","reliable","call_local")
func toggle_freeze(value: bool):
	emit_signal("toggle_freeze_called", value)

func set_collision_layer(value: int):
	emit_signal("set_collision_layer_called", value)

func set_collision_mask(value: int):
	emit_signal("set_collision_mask_called", value)	

func toggle_truce(value : bool) -> void:
	emit_signal("toggle_truce_called", value)