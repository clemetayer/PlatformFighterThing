extends Node2D

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(RuntimeUtils.GAME_ROOT_GROUP_NAME)

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"weapon_position": $"Position",
	"fire_position": $"Projectiles"
}

##### PUBLIC METHODS #####
func get_primary_weapon_position_node() -> Node2D:
	return onready_paths.weapon_position

func spawn_weapon(weapon):
	onready_paths.weapon_position.add_child(weapon)

func spawn_projectile(projectile_scene) -> void:
	onready_paths.fire_position.call_deferred("add_child",projectile_scene)

func get_projectiles() -> Array:
	return onready_paths.fire_position.get_children()

func clean_projectiles():
	for projectile in get_projectiles():
		projectile.queue_free()
