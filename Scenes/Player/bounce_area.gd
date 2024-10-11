extends Area2D
# mostly to trigger a camera shake on bounce

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant := 10 # Optionnal comment

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var collision_shape := $"CollisionShape2D"

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
func toggle_active(active: bool) -> void:
	set_deferred("monitoring", active)
	set_deferred("monitorable", active)
	collision_shape.set_deferred("disabled", !active)

##### SIGNAL MANAGEMENT #####
func _on_body_entered(body: Node2D) -> void:
	CameraEffects.emit_signal_start_camera_shake(0.07,CameraEffects.CAMERA_SHAKE_INTENSITY.LIGHT,CameraEffects.CAMERA_SHAKE_PRIORITY.LOW)
