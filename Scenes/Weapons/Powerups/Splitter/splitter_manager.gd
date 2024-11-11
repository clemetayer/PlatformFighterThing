extends PowerupBase
# Manages the spawn of the splitter powerup

##### VARIABLES #####
#---- CONSTANTS -----
const SPLITTER_PATH := "res://Scenes/Weapons/Powerups/Splitter/splitter.tscn"

#---- STANDARD -----
#==== PRIVATE ====
var _can_use_powerup := true 

#==== ONREADY ====
@onready var _splitter_load = load(SPLITTER_PATH)
@onready var onready_paths := {
	"cooldown_timer": $"CooldownTimer"
}

##### PUBLIC METHODS #####
func use() -> void:
	if _can_use_powerup:
		var powerup = _splitter_load.instantiate()
		powerup.global_position = self.global_position
		var game_root = RuntimeUtils.get_game_root()
		if game_root != null and game_root.has_method("spawn_powerup"):
			RuntimeUtils.get_game_root().spawn_powerup(powerup)
		else:
			Logger.error("game root is null or does not contain the method %s" % "spawn_powerup")
		_can_use_powerup = false
		onready_paths.cooldown_timer.start()

##### SIGNAL MANAGEMENT #####
func _on_cooldown_timer_timeout() -> void:
	_can_use_powerup = true
