extends Node2D

##### SIGNALS #####
# Node signals

##### ENUMS #####
enum DIRECTION {DOWN, LEFT, RIGHT}

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# @export var EXPORT_NAME := 10.0 # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths := {
	"player": $"Player",
	"particles": {
		"down": $"WallBreakParticles/Down",
		"left": $"WallBreakParticles/Left",
		"right": $"WallBreakParticles/Right"
	},
	"walls": {
		"down": $"DestructibleWalls/Down",
		"left": $"DestructibleWalls/Left",
		"right": $"DestructibleWalls/Right"
	}
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
func get_player() -> Node2D:
	return onready_paths.player

func get_player_config(_id : int) -> PlayerConfig:
	return load("res://test/integration/Common/default_player_config.tres")

func get_particles(direction : DIRECTION) -> Node2D:
	match direction:
		DIRECTION.DOWN:
			return onready_paths.particles.down
		DIRECTION.LEFT:
			return onready_paths.particles.left
		DIRECTION.RIGHT:
			return onready_paths.particles.right
	return null # should not happen

func get_wall(direction : DIRECTION) -> Node2D:
	match direction:
		DIRECTION.DOWN:
			return onready_paths.walls.down
		DIRECTION.LEFT:
			return onready_paths.walls.left
		DIRECTION.RIGHT:
			return onready_paths.walls.right
	return null # should not happen

func is_spawn_animation_playing(direction : DIRECTION) -> bool:
	return get_wall(direction).onready_paths.visual_effects_manager.onready_paths.spawn_animation._animation_tween.is_running()

func set_wall_life(direction : DIRECTION, life : float) -> void:
	var wall = get_wall(direction)
	wall.onready_paths.health_manager.apply_damage(wall.BASE_HEALTH - life)