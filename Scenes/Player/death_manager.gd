# @tool
extends Node
# class_name Class
# docstring

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const DEATH_ANIM_TIME := 2 #s

#---- EXPORTS -----
# @export var EXPORT_NAME := 10.0 # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths_node := $"../Paths"
@onready var onready_paths := {
	"particles": $"DeathParticles",
	"sound": $"DeathSound"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
func set_particles_color(color : Color) -> void:
	onready_paths.particles.modulate = color

# Triggers the death animation
func kill() -> void:
	onready_paths.particles.emitting = true
	onready_paths.sound.play()
	onready_paths_node.player_root.toggle_freeze(true)
	# disables the collisions, just in case
	onready_paths_node.player_root.set_collision_layer(0)
	onready_paths_node.player_root.set_collision_mask(0) 
	onready_paths_node.damage_label.hide()
	onready_paths_node.sprites.hide()
	onready_paths_node.primary_weapon.hide()
	await get_tree().create_timer(DEATH_ANIM_TIME).timeout
	onready_paths_node.player_root.emit_signal("killed", onready_paths_node.player_root.id)
	onready_paths_node.player_root.queue_free()

##### PROTECTED METHODS #####
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass
