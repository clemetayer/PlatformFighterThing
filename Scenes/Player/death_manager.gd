extends Node
# Script to manage the death animation of the player

##### VARIABLES #####
#---- CONSTANTS -----
const DEATH_ANIM_TIME := 2 #s

#---- STANDARD -----
#==== PRIVATE ====
var _last_hit_owner : RigidBody2D = null

#==== ONREADY ====
@onready var onready_paths_node := $"../Paths"
@onready var onready_paths := {
	"particles": $"DeathParticles",
	"sound": $"DeathSound"
}

##### PUBLIC METHODS #####
func set_particles_color(color : Color) -> void:
	onready_paths.particles.modulate = color

func set_last_hit_owner(last_hit_owner : RigidBody2D) -> void:
	_last_hit_owner = last_hit_owner

# Triggers the death animation
func kill() -> void:
	if is_instance_valid(_last_hit_owner):
		onready_paths_node.player_root.emit_signal("game_message_triggered", _get_last_hit_owner_message(_last_hit_owner))
	onready_paths.particles.emitting = true
	onready_paths_node.player_root.toggle_freeze(true)
	# disables the collisions, just in case
	onready_paths_node.player_root.set_collision_layer(0)
	onready_paths_node.player_root.set_collision_mask(0) 
	onready_paths_node.damage_label.hide()
	onready_paths_node.sprites.hide()
	onready_paths_node.primary_weapon.hide()
	onready_paths.sound.play()
	await get_tree().create_timer(DEATH_ANIM_TIME).timeout
	onready_paths_node.player_root.emit_signal("killed", onready_paths_node.player_root.id)
	onready_paths_node.player_root.queue_free()

##### PROTECTED METHODS #####
func _get_last_hit_owner_message(last_hit_owner : RigidBody2D) -> String:
	if "CONFIG" in last_hit_owner and last_hit_owner.CONFIG is PlayerConfig:
		return last_hit_owner.CONFIG.ELIMINATION_TEXT
	Logger.warn("Error while getting the opponent elimination text")
	return ""
