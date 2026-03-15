extends ActionLeaf

class_name ActionUsePowerup
# Action to use powerup

##### PROCESSING #####
func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.trigger_use_powerup()
	return SUCCESS
