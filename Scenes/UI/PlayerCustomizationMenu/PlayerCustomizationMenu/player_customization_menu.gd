extends MarginContainer
# handles the menu to configure the player appearance

##### SIGNALS #####
signal body_color_changed(new_color: Color)
signal outline_color_changed(new_color: Color)
signal eyes_changed(eyes_image_path: String)
signal mouth_changed(mouth_image_path: String)

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const EYES_PATHS := [
	"res://Scenes/Player/Eyes/eyes_1.png"
]

const MOUTHS_PATHS := [
	"res://Scenes/Player/Mouths/mouth_1.png"
]

#---- EXPORTS -----
# @export var EXPORT_NAME := 10.0 # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
# var _private_var # Optionnal comment

#==== ONREADY ====
@onready var onready_paths := {
	"main_color": $"VBoxContainer/Control/VBoxContainer/Elements/Buttons/MainColorPicker",
	"secondary_color": $"VBoxContainer/Control/VBoxContainer/Elements/Buttons/SecondaryColorPicker",
	"eyes_root": $"VBoxContainer/Control/Eyes",
	"eyes_items": $"VBoxContainer/Control/Eyes/EyesItems",
	"eyes_preview": $"VBoxContainer/Control/VBoxContainer/Elements/Buttons/Eyes/Preview",
	"mouth_root": $"VBoxContainer/Control/Mouth",
	"mouth_items": $"VBoxContainer/Control/Mouth/MouthItems",
	"mouth_preview": $"VBoxContainer/Control/VBoxContainer/Elements/Buttons/Mouth/Preview"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_init_items()

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _init_items() -> void:
	_init_item_list(onready_paths.eyes_items, EYES_PATHS)
	_init_item_list(onready_paths.mouth_items, MOUTHS_PATHS)

func _init_item_list(item_list: ItemList, elements: Array) -> void:
	item_list.clear()
	for path in elements:
		item_list.add_item("", load(path))

func _random_color() -> Color:
	return Color(randf(), randf(), randf())

##### SIGNAL MANAGEMENT #####
func _on_randomize_button_pressed() -> void:
	onready_paths.main_color.color = _random_color()
	onready_paths.secondary_color.color = _random_color()
	onready_paths.eyes_items.select(randi_range(0, EYES_PATHS.size() - 1))
	onready_paths.mouth_items.select(randi_range(0, MOUTHS_PATHS.size() - 1))

func _on_main_color_picker_color_changed(color: Color) -> void:
	emit_signal("body_color_changed", color)

func _on_secondary_color_picker_color_changed(color: Color) -> void:
	emit_signal("outline_color_changed", color)

func _on_eyes_edit_button_pressed() -> void:
	onready_paths.eyes_root.show()

func _on_mouth_edit_button_pressed() -> void:
	onready_paths.mouth_root.show()

func _on_eyes_items_item_activated(index: int) -> void:
	onready_paths.eyes_preview.texture = load(EYES_PATHS[index])
	emit_signal("eyes_changed", EYES_PATHS[index])

func _on_eyes_close_button_pressed() -> void:
	onready_paths.eyes_root.hide()

func _on_mouth_items_item_activated(index: int) -> void:
	onready_paths.mouth_preview.texture = load(MOUTHS_PATHS[index])
	emit_signal("mouth_changed", MOUTHS_PATHS[index])

func _on_mouth_close_button_pressed() -> void:
	onready_paths.mouth_root.hide()
