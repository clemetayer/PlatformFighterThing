extends ConditionLeaf

class_name ConditionIsPlayerClose

# Conditions that activates if the minimum distance to a player is below the treshold

##### VARIABLES #####
#---- EXPORTS -----
@export var DISTANCE_TRESHOLD := 400.0


##### PROCESSING #####
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var player = actor.get_player()
	var opponents_positions = actor.get_opponents_positions()
	if _all_positions_valid(opponents_positions) and _get_min_distance_to_player(player.get_global_position(), opponents_positions) <= DISTANCE_TRESHOLD:
		return SUCCESS
	return FAILURE


##### PROTECTED METHODS #####
func _all_positions_valid(positions: Array) -> bool:
	if positions.size() <= 0:
		return false
	for position in positions:
		if position == null:
			return false
	return true


func _get_min_distance_to_player(player_position: Vector2, opponents_positions: Array) -> float:
	var distance = player_position.distance_to(opponents_positions[0])
	for opponent_position in opponents_positions:
		if player_position.distance_to(opponent_position) < distance:
			distance = player_position.distance_to(opponent_position)
	return distance
