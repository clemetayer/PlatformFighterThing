class_name ActionAimAtTarget
extends ActionLeaf

##### VARIABLES #####
#---- EXPORTS -----
@export var ACQUIRE_TARGET_SPEED := 500.0 # move towards speed per delta time

#---- STANDARD -----
#==== PRIVATE ====
var _delta: float


##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	_delta = delta


##### PUBLIC METHODS #####
func tick(actor: Node, blackboard: Blackboard) -> int:
	var player = actor.get_player()
	var target = actor.get_target()
	if is_instance_valid(player) and is_instance_valid(target):
		var aim_position = actor.get_relative_aim_position()
		var global_aim_position: Vector2 = player.get_global_position() + aim_position
		global_aim_position = global_aim_position.move_toward(target.get_global_position(), _delta * ACQUIRE_TARGET_SPEED)
		aim_position = global_aim_position - player.get_global_position()
		actor.set_relative_aim_position(aim_position)
	return SUCCESS
	
