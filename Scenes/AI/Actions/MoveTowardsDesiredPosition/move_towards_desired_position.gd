extends ActionLeaf

class_name MoveTowardsDesiredPosition
# makes the player move towards a specific position

##### PROCESSING #####
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var player = actor.get_player()
	var target = actor.get_desired_position()
	if is_instance_valid(player):
		if player.get_global_position().x == target.x:
			actor.set_movement_direction(0)
		elif player.get_global_position().x > target.x:
			actor.set_movement_direction(-1)
		else:
			actor.set_movement_direction(1)
		actor.set_jump(player.get_global_position().y > target.y)
	else:
		actor.set_movement_direction(0)
		actor.set_jump(false)
	return SUCCESS
