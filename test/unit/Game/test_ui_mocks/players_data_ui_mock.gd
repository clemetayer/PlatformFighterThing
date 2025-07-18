extends Control
# mocks the player data ui for testing purposes

##### SIGNALS #####
signal clean_called
signal add_player_called(player_id: int, config: PlayerConfig, lives: int)
signal update_movement_called(player_id: int, value)
signal update_powerup_called(player_id: int, value)
signal update_lives_called(player_id: int, value)

##### PUBLIC METHODS #####
func clean() -> void:
	emit_signal("clean_called")

func add_player(player_id: int, config: PlayerConfig, lives: int) -> void:
	emit_signal("add_player_called", player_id, config, lives)

@rpc("any_peer","reliable","call_local")
func update_movement(player_id: int, value) -> void:
	emit_signal("update_movement_called", player_id, value)

@rpc("any_peer","reliable","call_local")
func update_powerup(player_id: int, value) -> void:
	emit_signal("update_powerup_called", player_id, value)

@rpc("any_peer","reliable","call_local")
func update_lives(player_id: int, value) -> void:
	emit_signal("update_lives_called", player_id, value)