# AI action leaf to move towards the target
class_name ActionMoveTowardsTarget
extends ActionLeaf

##### PROCESSING #####
func tick(actor: Node, blackboard: Blackboard) -> int:
	var player = actor.get_player()
	var target = actor.get_target()
	if is_instance_valid(player) and is_instance_valid(target):
		if player.get_global_position().x == target.get_global_position().x:
			actor.set_movement_direction(0)
		elif player.get_global_position().x > target.get_global_position().x:
			actor.set_movement_direction(-1)
		else:
			actor.set_movement_direction(1)
		actor.set_jump(player.get_global_position().y > target.get_global_position().y)
	else:
		actor.set_movement_direction(0)
		actor.set_jump(false)
	return SUCCESS
