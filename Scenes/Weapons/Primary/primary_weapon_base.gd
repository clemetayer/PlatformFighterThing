extends Node2D
class_name PrimaryWeaponBase
# Base class for the primary weapon

##### SIGNALS #####

##### PROCESSING #####

##### PUBLIC METHODS #####
func fire() -> void:
	pass

func aim(direction : Vector2) -> void:
	pass

##### PROTECTED METHODS #####
func _spawn_projectile(projectile : Node) -> void:
	var game_root = RuntimeUtils.get_game_root()
	if game_root != null and game_root.has_method("spawn_projectile"):
		game_root.spawn_projectile(projectile)
	else: 
		Logger.error("Game root does not exist or does not have the method '%s'" % "spawn_projectile")
