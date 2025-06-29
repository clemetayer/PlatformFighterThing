extends Node2D
# script to manage the respawn of the destructible wall

##### SIGNALS #####
signal wall_respawned

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"respawn_timer": $"RespawnTimer",
	"wait_respawn_timer": $"WaitRespawnTimer",
	"collision_detection_area": $"CollisionDetectionArea"
}

##### PUBLIC METHODS #####
func enable_respawn_detection(active: bool) -> void:
	onready_paths.collision_detection_area.set_deferred("monitoring", active)
	onready_paths.collision_detection_area.set_deferred("monitorable", active)

func start_respawn_timer() -> void:
	onready_paths.respawn_timer.start()

##### PROTECTED METHODS #####
func _has_obstacles_in_area() -> bool:
	return onready_paths.collision_detection_area.has_overlapping_bodies()

func _check_and_respawn() -> void:
	if _has_obstacles_in_area():
		onready_paths.wait_respawn_timer.start()
	else:
		emit_signal("wall_respawned")

##### SIGNAL MANAGEMENT #####
func _on_respawn_timer_timeout() -> void:
	_check_and_respawn()

func _on_wait_respawn_timer_timeout() -> void:
	_check_and_respawn()
