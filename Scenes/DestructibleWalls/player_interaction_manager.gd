extends Node
# handles the player interactions with the destructible wall

##### VARIABLES #####
#---- CONSTANTS -----
const FREEZE_PLAYER_TIMEOUT := 1.0 # seconds
const WALL_BREAK_KNOCKBACK_STRENGTH := 10000

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"freeze_player_timers" : $"FreezePlayerTimers",
	"audio_manager": $"../AudioManager",
	"health_manager" : $"../HealthManager"
}

##### PUBLIC METHODS #####
func handle_player_hit(player: Node2D, bounce_direction: Vector2, bounce_force: float) -> void:
	player.rpc("toggle_freeze", true)
	_start_freeze_timeout_timer_for_player(player, bounce_direction, bounce_force)

func kill_player(player: Node2D) -> void:
	player.rpc("kill")

##### PROTECTED METHODS #####
func _start_freeze_timeout_timer_for_player(player: Node2D, bounce_direction: Vector2, bounce_force: float, time: float = FREEZE_PLAYER_TIMEOUT) -> void:
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = time
	timer.connect("timeout", func(): _on_freeze_player_timer_timeout(timer, player, bounce_direction, bounce_force))
	onready_paths.freeze_player_timers.add_child(timer)
	timer.start()

##### SIGNAL MANAGEMENT #####
func _on_freeze_player_timer_timeout(timer_to_free: Timer, player: Node2D, bounce_direction: Vector2, bounce_force: float) -> void:
	if RuntimeUtils.is_authority() and is_instance_valid(player):
		onready_paths.audio_manager.stop_trebble()
		player.rpc("toggle_freeze", false)
		if onready_paths.health_manager.is_destroyed():
			player.rpc("override_velocity", -bounce_direction.normalized() * WALL_BREAK_KNOCKBACK_STRENGTH)
		else:
			player.rpc("override_velocity", bounce_direction.normalized() * bounce_force)
		timer_to_free.queue_free()
