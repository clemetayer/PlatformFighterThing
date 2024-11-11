extends PowerupBase
# Manages the spawn of the splitter powerup

##### VARIABLES #####
#---- CONSTANTS -----
const SPLITTER_PATH := "res://Scenes/Weapons/Powerups/Splitter/splitter.tscn"
const MAX_SPLITTERS_ACTIVE := 3

#---- STANDARD -----
#==== PRIVATE ====
var _can_use_powerup := true 
var _splitters_active := [] # splitters active for the player

#==== ONREADY ====
@onready var _splitter_load = load(SPLITTER_PATH)
@onready var onready_paths := {
	"cooldown_timer": $"CooldownTimer"
}

##### PUBLIC METHODS #####
func use() -> void:
	if _can_use_powerup:
		if _splitters_active.size() >= MAX_SPLITTERS_ACTIVE:
			_remove_last_splitter()
		var powerup = _splitter_load.instantiate()
		powerup.global_position = self.global_position
		var game_root = RuntimeUtils.get_game_root()
		if game_root != null and game_root.has_method("spawn_powerup"):
			RuntimeUtils.get_game_root().spawn_powerup(powerup)
			_splitters_active.push_front(powerup)
			powerup.connect("destroyed",_on_splitter_destroyed)
		else:
			Logger.error("game root is null or does not contain the method %s" % "spawn_powerup")
		_can_use_powerup = false
		onready_paths.cooldown_timer.start()

##### PROTECTED METHODS #####
func _remove_last_splitter() -> void:
	var splitter = _splitters_active.pop_back()
	splitter.queue_free()

##### SIGNAL MANAGEMENT #####
func _on_cooldown_timer_timeout() -> void:
	_can_use_powerup = true

func _on_splitter_destroyed(splitter : Node2D) -> void :
	_splitters_active.erase(splitter)
