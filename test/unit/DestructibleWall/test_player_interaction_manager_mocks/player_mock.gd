extends Node2D
# specific mock to simulate some native methods of a player that can't be mocked with GUT 
# and needed in test_player_interaction_manager.gd, mostly rpcs.
# Note for rpcs : always add the scene as a child and wait for it to enter the tree, otherwise rpcs won't work

##### SIGNALS #####
signal toggle_freeze_called(value : bool)
signal override_velocity_called(bounce_direction : Vector2)
signal kill_called

##### PUBLIC METHODS #####
@rpc("any_peer","reliable","call_local")
func toggle_freeze(value : bool):
	emit_signal("toggle_freeze_called", value)

@rpc("any_peer","reliable","call_local")
func override_velocity(bounce_direction : Vector2):
	emit_signal("override_velocity_called", bounce_direction)

@rpc("any_peer","reliable","call_local")
func kill():
	emit_signal("kill_called")
