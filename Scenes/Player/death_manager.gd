extends Node
# Script to manage the death animation of the player

##### VARIABLES #####
##### VARIABLES #####
#---- CONSTANTS -----
const CAMERA_DEATH_IMPACT_TIME := 1 #s

#---- STANDARD -----
#==== PRIVATE ====
var _last_hit_owner : Node2D = null

#==== ONREADY ====
@onready var onready_paths_node := $"../Paths"
@onready var onready_paths := {
	"particles": $"DeathParticles",
	"sound": $"DeathSound",
	"death_anim_time": $"DeathAnimTime"
}

##### PUBLIC METHODS #####
func set_particles_color(color : Color) -> void:
	onready_paths.particles.modulate = color

func set_last_hit_owner(last_hit_owner : Node2D) -> void:
	_last_hit_owner = last_hit_owner

# Triggers the death animation
@rpc("authority", "call_local", "reliable")
func kill() -> void:
	CameraEffects.emit_signal_start_camera_impact(CAMERA_DEATH_IMPACT_TIME,CameraEffects.CAMERA_IMPACT_INTENSITY.HIGH, CameraEffects.CAMERA_IMPACT_PRIORITY.HIGH)
	if is_instance_valid(_last_hit_owner):
		onready_paths_node.player_root.emit_signal("game_message_triggered", _get_last_hit_owner_id(_last_hit_owner))
	onready_paths.particles.emitting = true
	onready_paths_node.player_root.toggle_freeze(true)
	# disables the collisions, just in case
	onready_paths_node.player_root.set_collision_layer(0)
	onready_paths_node.player_root.set_collision_mask(0) 
	onready_paths_node.damage_label.hide()
	onready_paths_node.sprites.hide()
	onready_paths_node.primary_weapon.hide()
	onready_paths.sound.play()
	onready_paths.death_anim_time.start()

##### PROTECTED METHODS #####
func _get_last_hit_owner_id(last_hit_owner : Node2D) -> int:
	if "id" in last_hit_owner:
		return last_hit_owner.id
	Logger.warn("Error while getting the opponent id to show the elmination message")
	return -1

func _on_death_anim_time_timeout() -> void:
	onready_paths_node.player_root.emit_signal("killed", onready_paths_node.player_root.id)
	onready_paths_node.player_root.queue_free()
