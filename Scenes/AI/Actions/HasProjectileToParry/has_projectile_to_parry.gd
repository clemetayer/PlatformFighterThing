extends ConditionLeaf

# success if the player has a projectile nearby that can be parried

##### VARIABLES #####
#---- CONSTANTS -----
const PARRY_DISTANCE := 75.0 # Distance from the projectile where the AI should consider that this is a good idea to parry


##### PROCESSING #####
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var has_close_projectile = _get_min_distance_to_projectile(actor.get_player(), actor.get_projectiles()) <= PARRY_DISTANCE
	return SUCCESS if has_close_projectile else FAILURE


##### PROTECTED METHODS #####
func _get_min_distance_to_projectile(player: Node2D, projectiles: Array) -> float:
	if not (is_instance_valid(player) and projectiles.size() > 0):
		return INF
	var player_pos = player.get_global_position()
	var projectile_pos = projectiles[0].get_global_position()
	var min_distance = player_pos.distance_to(projectile_pos)
	for projectile in projectiles:
		if is_instance_valid(projectile):
			projectile_pos = projectile.get_global_position()
			var distance = player_pos.distance_to(projectile_pos)
			if distance < min_distance:
				min_distance = distance
	return min_distance
