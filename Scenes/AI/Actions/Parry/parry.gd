extends ActionLeaf

# Action to parry

##### PROCESSING #####
func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.trigger_parry()
	return SUCCESS
