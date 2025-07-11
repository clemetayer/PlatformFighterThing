extends Node
# Handles the spawn entrance animation for the destructible wall

##### VARIABLES #####
#---- CONSTANTS -----
const BASE_OFFSET := 500
const ANIMATION_TIME := 1 #s
const SPARKS_TIME := 0.25 #s

#---- STANDARD -----
#==== PRIVATE ====
var _animation_tween : Tween

#==== ONREADY ====
@onready var root := $"../../"
@onready var onready_paths := {
	"particles": $"../Particles",
	"audio": $"SpawnSound"
}

##### PUBLIC METHODS #####
func play_spawn_animation(direction : Vector2) -> void:
	onready_paths.audio.play()
	root.position = -direction * BASE_OFFSET
	if _animation_tween != null:
		_animation_tween.kill()
	_animation_tween = create_tween()
	_animation_tween.tween_property(root, "position", Vector2.ZERO, ANIMATION_TIME).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	await _animation_tween.finished
	onready_paths.particles.toggle_emit(true)
	_add_sparks_time_timer()

##### PROTECTED METHODS #####
func _add_sparks_time_timer():
	var timer = Timer.new()
	timer.connect("timeout",_on_sparks_timer_timeout)
	add_child(timer)
	timer.start(SPARKS_TIME)
	await timer.timeout
	timer.queue_free()

##### SIGNAL MANAGEMENT #####
func _on_sparks_timer_timeout() -> void:
	onready_paths.particles.toggle_emit(false)
