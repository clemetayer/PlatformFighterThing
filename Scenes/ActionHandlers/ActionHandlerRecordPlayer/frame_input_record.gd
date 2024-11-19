extends Resource
class_name FrameInputRecord
# record of the inputs not inactive in a frame

##### VARIABLES #####
#---- STANDARD -----
#==== PUBLIC ====
var inputs : Array[SingleInputRecord] = []
var relative_aim_position : Vector2 # aim position depending on the player position
var frame_time := 0.0
