extends Node

# level for the ai integration tests

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var players := $"Players"
@onready var level := $"Level"
@onready var projectiles := $"Projectiles"
@onready var powerups := $"Powerups"


##### PUBLIC METHODS #####
func init_players_data(p_players_data: Dictionary) -> void:
	players.init_players_data(p_players_data)


func add_game_elements() -> void:
	players.init_spawn_positions(level.get_spawn_points())
	players.add_players()


func spawn_powerup(powerup: Node) -> void:
	powerup.name = "powerup_%d" % powerups.get_child_count()
	powerups.call_deferred("add_child", powerup, true)


func spawn_projectile(projectile: Node) -> void:
	projectiles.call_deferred("add_child", projectile, true)


func toggle_players_truce(active: bool) -> void:
	players.toggle_players_truce(active)
