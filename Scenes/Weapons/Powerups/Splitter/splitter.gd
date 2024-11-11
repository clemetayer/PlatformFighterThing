extends Node2D
# Powerups that duplicates a bullet in two bullets

##### SIGNALS #####
signal destroyed

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const MAX_CONTACTS := 3

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

##### SIGNAL MANAGEMENT #####
func _on_hitbox_area_entered(area):
	if RuntimeUtils.is_authority():
		if area.is_in_group("projectile") and not _whitelist.has(area):
			var duplicated_projectile = area.duplicate()
			duplicated_projectile.current_owner = area.current_owner
			_spawn_projectile(duplicated_projectile)
			area.rotate(PI/4)
			duplicated_projectile.rotate(-PI/4)
			duplicated_projectile._direction = Vector2.RIGHT.rotated(duplicated_projectile.rotation).normalized()
			area._direction = Vector2.RIGHT.rotated(area.rotation).normalized()
			_whitelist.append(area)
			_whitelist.append(duplicated_projectile)
		if _contacts_count <= MAX_CONTACTS:
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
