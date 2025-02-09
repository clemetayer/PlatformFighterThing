extends Sprite2D
# Simple script that manages the triangle city lead sprite movement

##### VARIABLES #####
#---- CONSTANTS -----
const MOVEMENT_SPEED = 2000.0

##### PROCESSING #####
# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(delta):
	position.x -= delta * MOVEMENT_SPEED

##### SIGNAL MANAGEMENT #####
func _on_timer_timeout() -> void:
	queue_free()
