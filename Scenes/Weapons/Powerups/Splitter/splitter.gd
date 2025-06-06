extends Node2D
# Powerups that duplicates a projectile in multiple projectiles

##### SIGNALS #####
signal destroyed

##### VARIABLES #####
#---- CONSTANTS -----
const MAX_CONTACTS := 3
const PROJECTILE_DUPLICATES := 5 # note : most likely should be an uneven number (to let the original projectile keep its trajectory)

#---- STANDARD -----
#==== PRIVATE ====
var _whitelist := [] # to avoid duplicating too much (with the fresh new projectiles for instance)
var _contacts_count := 0

#==== ONREADY ====
@onready var onready_paths := {
	"audio":$"AudioStreamPlayer2D",
	"collision": $"Hitbox/CollisionShape2D",
	"sprite": $"Sprite2D",
	"circles": $"Circles"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.circles.init(MAX_CONTACTS)

##### PROTECTED METHODS #####
func _spawn_projectile(projectile) -> void:
	var game_root = RuntimeUtils.get_game_root()
	if game_root != null and game_root.has_method("spawn_projectile"):
		game_root.spawn_projectile(projectile)
	else: 
		Logger.error("Game root does not exist or does not have the method '%s'" % "spawn_projectile")

func _duplicate_projectile_with_angle(projectile : Node, angle : float) -> void:
	var duplicated_projectile = projectile.duplicate()
	duplicated_projectile.current_owner = projectile.current_owner
	_spawn_projectile(duplicated_projectile)
	duplicated_projectile.rotate(angle)
	duplicated_projectile._direction = Vector2.RIGHT.rotated(duplicated_projectile.rotation).normalized()
	_whitelist.append(duplicated_projectile)

@rpc("authority", "call_local", "reliable")
func _handle_feedback() -> void:
	onready_paths.audio.play()
	onready_paths.circles.remove_circle()

@rpc("authority", "call_local", "reliable")
func _prepare_for_deletion() -> void:
	onready_paths.collision.set_deferred("disabled", true)
	onready_paths.sprite.hide()
	if onready_paths.audio.playing:
		await onready_paths.audio.finished
	emit_signal("destroyed", self)
	queue_free()

##### SIGNAL MANAGEMENT #####
# Note : the PROJECTILE_DUPLICATES + 1 thing seems weird, but it's actually needed to spawn an even amount of bullets
func _on_hitbox_area_entered(area):
	if RuntimeUtils.is_authority():
		if area.is_in_group("projectile") and not _whitelist.has(area):
			rpc("_handle_feedback")
			for duplicate_idx in range(1,PROJECTILE_DUPLICATES + 1):
				var dup_angle = (duplicate_idx * ((PI/2)/(PROJECTILE_DUPLICATES+1))) - PI/4
				if dup_angle != PI/2: # PI/2 angle (forward) is reserved for the original projectile
					_duplicate_projectile_with_angle(area,dup_angle)
			if PROJECTILE_DUPLICATES % 2 == 0:
				area.queue_free()
			else:
				_whitelist.append(area)
			if _contacts_count < MAX_CONTACTS - 1:
				_contacts_count += 1
			else:
				rpc("_prepare_for_deletion")

func _on_hitbox_body_entered(body):
	pass # Replace with function body.

func _on_hitbox_area_exited(area):
	if _whitelist.has(area) and RuntimeUtils.is_authority():
		_whitelist.erase(area)

func _on_hitbox_body_exited(body):
	pass # Replace with function body.
