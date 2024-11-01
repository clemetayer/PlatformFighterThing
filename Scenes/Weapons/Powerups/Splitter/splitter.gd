extends PowerupBase
# Powerups that duplicates a bullet in two bullets
# FIXME ? When placing two splitters inside each other, this creates a temporary bullet generator. But this is kind of cool, keep it as a feature ? The amount of bullets produced will probably depend on the general PC performances

##### SIGNALS #####
# Node signals

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
# Methods that are intended to be used exclusively by this scripts
# func _private_method(arg):
#     pass

##### SIGNAL MANAGEMENT #####
func _on_hitbox_area_entered(area):
	if area.is_in_group("projectile") and not _whitelist.has(area):
		var duplicate = area.duplicate()
		duplicate.current_owner = area.current_owner
		get_tree().current_scene.call_deferred("add_child",duplicate)
		area.rotate(PI/4)
		duplicate.rotate(-PI/4)
		duplicate._direction = Vector2.RIGHT.rotated(duplicate.rotation).normalized()
		area._direction = Vector2.RIGHT.rotated(area.rotation).normalized()
		_whitelist.append(area)
		_whitelist.append(duplicate)
	if _contacts_count <= MAX_CONTACTS:
		_contacts_count += 1
	else:
		queue_free()
		

func _on_hitbox_body_entered(body):
	pass # Replace with function body.

func _on_hitbox_area_exited(area):
	if _whitelist.has(area):
		_whitelist.erase(area)

func _on_hitbox_body_exited(body):
	pass # Replace with function body.
