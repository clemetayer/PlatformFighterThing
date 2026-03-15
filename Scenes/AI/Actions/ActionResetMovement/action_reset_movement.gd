extends ActionLeaf

class_name ActionResetMovement
# action that resets the desired movement for the player

##### PROCESSING #####
func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.set_jump(false)
	actor.set_movement_direction(0)
	return SUCCESS
