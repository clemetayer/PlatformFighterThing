extends Node

# stub of the tree, for test purposes

##### VARIABLES #####
#---- STANDARD -----
#==== PUBLIC ====
var nodes_in_group := { }


##### PUBLIC METHODS #####
func get_nodes_in_group(group_name: String) -> Array:
	return nodes_in_group[group_name]
