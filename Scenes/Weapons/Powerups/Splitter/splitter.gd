extends Node2D
# Powerups that duplicates a projectile in multiple projectiles

##### SIGNALS #####
signal destroyed

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const MAX_CONTACTS := 3
const PROJECTILE_DUPLICATES := 5 # note : most likely should be an uneven number (to let the original projectile keep its trajectory)

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _whitelist := [] # to avoid duplicating too much (with the fresh new projectiles for instance)
var _contacts_count := 0

#==== ONREADY ====
# onready var onready_var # Optionnal comment

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg ):
#     pass

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

##### SIGNAL MANAGEMENT #####
# Note : the PROJECTILE_DUPLICATES + 1 thing seems weird, but it's actually needed to spawn an even amount of bullets
func _on_hitbox_area_entered(area):
	if RuntimeUtils.is_authority():
		if area.is_in_group("projectile") and not _whitelist.has(area):
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
				emit_signal("destroyed", self)
				queue_free()

func _on_hitbox_body_entered(body):
	pass # Replace with function body.

func _on_hitbox_area_exited(area):
	if _whitelist.has(area) and RuntimeUtils.is_authority():
		_whitelist.erase(area)

func _on_hitbox_body_exited(body):
	pass # Replace with function body.
