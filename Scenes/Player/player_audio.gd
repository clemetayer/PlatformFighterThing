extends Node2D

# handles the audio for the player

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var hit := $"Hit"


##### SIGNAL MANAGEMENT #####
func _on_player_damage_received(_old_damage: float, _new_damage: float, _knockback: Vector2) -> void:
	hit.play()
