extends Node
# Script to manage the death animation of the player

##### VARIABLES #####
#---- CONSTANTS -----
const DEATH_ANIM_TIME := 2 #s

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths_node := $"../Paths"
@onready var onready_paths := {
	"particles": $"DeathParticles",
	"sound": $"DeathSound"
}

##### PUBLIC METHODS #####
func set_particles_color(color : Color) -> void:
	onready_paths.particles.modulate = color

# Triggers the death animation
@rpc("any_peer", "call_local", "reliable")
func kill() -> void:
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
