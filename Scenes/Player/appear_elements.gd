extends Node2D
# manages the elements for the spawn animation

##### SIGNALS #####
signal appear_animation_finished

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths_node := $"../Paths"
@onready var onready_paths := {
	"sprite": $"Appear",
	"particles": {
		"main":$"MainColor",
		"secondary":$"SecondaryColor"
	}
}

##### PUBLIC METHODS #####
func init(main_color : Color, secondary_color : Color) -> void:
	var main_color_light = main_color
	main_color_light.h = 50
	var secondary_color_light = secondary_color
	secondary_color_light.h = 50
	onready_paths.sprite.modulate = main_color_light
	onready_paths.particles.main.modulate = main_color_light
	onready_paths.particles.secondary.modulate = secondary_color_light

func play_spawn_animation() -> void:
	onready_paths_node.animation_player.play("appear")
	await onready_paths_node.animation_player.animation_finished
	emit_signal("appear_animation_finished")
