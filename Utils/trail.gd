extends Line2D
# traces a bullet path line 

##### VARIABLES #####
#---- CONSTANTS -----
const SIZE := 15

#---- STANDARD -----
#==== PRIVATE ====
var _freeze := false

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	SceneUtils.connect("toggle_scene_freeze", _on_SceneUtils_toggle_scene_freeze)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	if not _freeze:
		# reset to origin since line2D uses the local coordinates
		global_position = Vector2.ZERO 
		global_rotation = 0
		
		# updates the points as a LIFO queue
		if get_point_count() >= SIZE:
			remove_point(0)
		add_point(get_parent().global_position)

##### SIGNAL MANAGEMENT #####
func _on_SceneUtils_toggle_scene_freeze(value : bool) -> void:
	_freeze = value
