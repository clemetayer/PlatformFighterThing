extends ActionLeaf

class_name ActionUseMovementBonus

# action to trigger the movement_bonus action

##### PROCESSING #####
func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.trigger_movement_bonus()
	return SUCCESS
