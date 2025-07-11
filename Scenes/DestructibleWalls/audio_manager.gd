extends Node
# Controls the audio of the breakable wall

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"hit_sound": $"WallHit",
	"break_sound": $"WallBreak",
	"trebble_sound": $"WallHitBreakTrebble"
}

##### PUBLIC METHODS #####
func play_hit() -> void:
	onready_paths.hit_sound.play()

func play_break() -> void:
	onready_paths.break_sound.play()

func play_trebble(damage_ratio: float) -> void:
	var final_stream_play_time = onready_paths.trebble_sound.get_stream().get_length() * (1.0 - damage_ratio)
	var initial_stream_play_time = max(0.0, final_stream_play_time - 1.0)
	onready_paths.trebble_sound.play(initial_stream_play_time)

func stop_trebble() -> void:
	onready_paths.trebble_sound.stop()
