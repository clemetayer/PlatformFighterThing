extends GPUParticles2D
# Manages the particles when the player is hit

##### VARIABLES #####
#---- CONSTANTS -----
const VELOCITY_RANGE := [500.0, 1000.0]
const VELOCITY_MULTIPLIERS := [1.0, 3.0, 7.0]
const VELOCITY_TRESHOLDS := [3000.0, 10000.0]

##### PUBLIC METHODS #####
func init(color: Color) -> void:
	process_material.color = color

func hit(pushback_velocity: Vector2) -> void:
	var multiplier = _get_multiplier(pushback_velocity)
	process_material.initial_velocity_min = VELOCITY_RANGE[0] * multiplier
	process_material.initial_velocity_max = VELOCITY_RANGE[1] * multiplier
	var direction = pushback_velocity.normalized()
	process_material.direction = Vector3(direction.x, direction.y, 0.0)
	emitting = true

##### PROTECTED METHODS #####
func _get_multiplier(velocity: Vector2) -> float:
	for treshold_idx in range(0, VELOCITY_TRESHOLDS.size()):
		if velocity.length() < VELOCITY_TRESHOLDS[treshold_idx]:
			return VELOCITY_MULTIPLIERS[treshold_idx]
	return VELOCITY_MULTIPLIERS[VELOCITY_TRESHOLDS.size()]
