extends Node
# Handles the camera position

##### PUBLIC METHODS #####
func get_average_position(players: Array) -> Vector2:
	var sum = Vector2.ZERO
	if players != null:
		for player in players:
			sum += player.global_position
		return sum / players.size()
	return Vector2.ZERO # should never go here
