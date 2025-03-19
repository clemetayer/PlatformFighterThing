extends Node
# Manages the histsun

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const MAX_HITSTUN_TIME := 3 # s
const MAX_HITSTUN_DAMAGE := 999 # damage points

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
var hitstunned := false

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths_node := $"../Paths"

##### PUBLIC METHODS #####
func stop_hitstun() -> void:
	if hitstunned:
		onready_paths_node.hitstun_timer.stop()
		_on_hitstun_timeout()

func start_hitstun(damage : float) -> void:
	var x = min(MAX_HITSTUN_DAMAGE, damage)/MAX_HITSTUN_DAMAGE
	var time = StaticUtils.cubic_ease_out(x) * MAX_HITSTUN_TIME
	onready_paths_node.hitstun_timer.start(time)
	onready_paths_node.animation_player.play("hitstun")
	onready_paths_node.player_root.toggle_hitstun_bounce(true)
	onready_paths_node.bounce_area.toggle_active(true)
	hitstunned = true
##### PROTECTED METHODS #####

##### SIGNAL MANAGEMENT #####
func _on_hitstun_timeout() -> void:
	hitstunned = false
	onready_paths_node.bounce_area.toggle_active(false)
	onready_paths_node.player_root.toggle_hitstun_bounce(false)
	onready_paths_node.animation_player.stop()
	onready_paths_node.animation_player.play("RESET")
