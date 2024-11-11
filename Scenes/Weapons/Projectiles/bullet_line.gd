extends Line2D
# traces a trail following the parent

##### VARIABLES #####
#---- CONSTANTS -----
const SIZE := 15

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	# reset to origin since line2D uses the local coordinates
	global_position = Vector2.ZERO 
	global_rotation = 0
	
	# updates the points as a LIFO queue
	if get_point_count() >= SIZE:
		remove_point(0)
	add_point(get_parent().global_position)
