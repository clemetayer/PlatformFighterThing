extends Area2D
# destructible wall script

##### VARIABLES #####
#---- CONSTANTS -----
const AREA_COLLISION_OFFSET := 50 # px

#---- EXPORTS -----
@export var BASE_HEALTH := 5000 
@export var BOUNCE_BACK_FORCE := 1200
@export var BOUNCE_BACK_DIRECTION := Vector2.RIGHT

#---- STANDARD -----
#==== PRIVATE ====
var _health = BASE_HEALTH

##### PROTECTED METHODS #####
func _remove_health_by_velocity(velocity: Vector2) -> void:
	if BOUNCE_BACK_DIRECTION.x != 0:
		_health -= abs(velocity.x)
	elif BOUNCE_BACK_DIRECTION.y != 0:
		_health -= abs(velocity.y)

##### SIGNAL MANAGEMENT #####
func _on_body_entered(body):
	if body.is_in_group("player"):
		_remove_health_by_velocity(body.velocity)
		if _health <= 0:
			queue_free()
		else:
			if body.has_method("bounce_back"):
				body.bounce_back(BOUNCE_BACK_DIRECTION * BOUNCE_BACK_FORCE)

func _on_area_entered(area):
	if area.is_in_group("projectile"):
		area.queue_free()
