extends Node2D

##### VARIABLES #####
#---- STANDARD -----
#==== PRIVATE ====

#==== ONREADY ====
@onready var onready_paths := {
	"fire_position_node": $"FirePosition" ,
	"powerup_position_node": $"PowerupPosition" 
}

##### PUBLIC METHODS #####
func get_fire_position_node():
	return onready_paths.fire_position_node

func get_powerup_position_node():
	return onready_paths.powerup_position_node

func get_projectiles():
	return onready_paths.fire_position_node.get_children()

func get_powerups():
	return onready_paths.powerup_position_node.get_children()

func fire_projectile(projectile_scene) -> void:
	onready_paths.fire_position_node.call_deferred("add_child",projectile_scene)

func spawn_powerup(powerup) -> void:
	onready_paths.powerup_position_node.call_deferred("add_child", powerup)

func clean_projectiles():
	for projectile in onready_paths.fire_position_node.get_children():
		projectile.queue_free()

func clean_powerups():
	for powerup in onready_paths.powerup_position_node.get_children():
		powerup.queue_free()

func spawn_projectile(projectile):
	fire_projectile(projectile)
