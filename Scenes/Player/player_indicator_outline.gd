extends Sprite2D

# handles the player indicator color outline
#
##### VARIABLES #####
#---- CONSTANTS -----
const MAX_ANIM_SPEED := 10.0
const MAX_DAMAGE_ANIM := 300.0

#---- STANDARD -----
#==== ONREADY ====
@onready var animation: AnimationPlayer = $"AnimationPlayer"


##### PUBLIC METHODS #####
func set_player_color(player_idx: int) -> void:
	modulate = RuntimeUtils.PLAYER_INDICATOR_COLORS[player_idx % 4]


func _on_player_damage_received(_old_damage: float, new_damage: float, _knockback: Vector2) -> void:
	var anim_speed := (new_damage / MAX_DAMAGE_ANIM) * MAX_ANIM_SPEED
	anim_speed = clamp(anim_speed, 1.0, MAX_ANIM_SPEED)
	animation.speed_scale = anim_speed
