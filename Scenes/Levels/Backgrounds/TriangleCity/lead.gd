extends Node2D
# used to spawn something for the lead

##### VARIABLES #####
#---- EXPORTS -----
@export var GRADIENT : GradientTexture1D

#==== ONREADY ====
@onready var LEAD_SPRITE_SCENE_LOAD := load("res://Scenes/Levels/Backgrounds/TriangleCity/triangle_city_lead_sprite.tscn")

##### PUBLIC METHODS #####
func spawn_sprite() -> void:
	var sprite = LEAD_SPRITE_SCENE_LOAD.instantiate()
	var rng = RandomNumberGenerator.new()
	var rand_col_offset = rng.randf_range(0.0, 1.0)
	sprite.modulate = GRADIENT.gradient.sample(rand_col_offset)
	var rand_y_pos = rng.randf_range(0.0, 324.0)
	sprite.position = Vector2(1152.0,rand_y_pos)
	sprite.scale = Vector2(0.5,3.0)
	sprite.rotation_degrees = -90
	add_child(sprite)
