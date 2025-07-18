extends Node
# mocks the screen messages (for rpcs especially)

##### SIGNALS #####
signal display_message_called(message: String, time : float, display_all_characters: bool)

##### PUBLIC METHODS #####
@rpc("any_peer","reliable","call_local")
func display_message(message: String, duration: float, display_all_characters: bool = false) -> void:
	emit_signal("display_message_called", message, duration, display_all_characters)
