class_name ActionShootTarget
extends ActionLeaf

##### PUBLIC METHODS #####
func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.fire()
	return SUCCESS
