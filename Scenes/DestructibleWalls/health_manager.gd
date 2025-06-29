extends Node
# handles the health of the destructible wall

##### SIGNALS #####
signal health_empty()
signal health_changed(new_health : float, old_health : float)

##### VARIABLES #####
#---- EXPORTS -----
@export var HEALTH : float

#---- STANDARD -----
#==== PRIVATE ====
var _base_health : float

##### PUBLIC METHODS #####
func init(base_health : float) -> void:
	HEALTH = base_health
	_base_health = base_health

func apply_damage(damage : float) -> void:
	var old_health = HEALTH
	HEALTH -= damage
	if HEALTH <= 0:
		emit_signal("health_empty")
		HEALTH = 0
	else:
		emit_signal("health_changed", HEALTH, old_health)

func reset_health() -> void:
	HEALTH = _base_health
	emit_signal("health_changed",HEALTH, HEALTH)

func get_health_ratio() -> float:
	return HEALTH / _base_health

func is_destroyed() -> bool:
	return HEALTH <= 0
