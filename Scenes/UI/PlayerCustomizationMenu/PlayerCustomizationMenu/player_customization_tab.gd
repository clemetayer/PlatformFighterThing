extends MarginContainer
# handles the menu to configure the player appearance

##### SIGNALS #####
signal body_color_changed(new_color: Color)
signal outline_color_changed(new_color: Color)
signal eyes_changed(eyes_image_path: String)
signal mouth_changed(mouth_image_path: String)

##### VARIABLES #####
#---- CONSTANTS -----
const EYES_PATHS := [
	"res://Scenes/Player/Eyes/eyes_1.png"
]

const MOUTHS_PATHS := [
	"res://Scenes/Player/Mouths/mouth_1.png"
]

#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"main_color": $"VBoxContainer/Control/VBoxContainer/HBoxContainer/VBoxContainer/Elements/Buttons/MainColorPicker",
	"secondary_color": $"VBoxContainer/Control/VBoxContainer/HBoxContainer/VBoxContainer/Elements/Buttons/SecondaryColorPicker",
	"eyes_root": $"VBoxContainer/Control/Eyes",
	"eyes_items": $"VBoxContainer/Control/Eyes/EyesItems",
	"mouth_root": $"VBoxContainer/Control/Mouth",
	"mouth_items": $"VBoxContainer/Control/Mouth/MouthItems",
	"sprite_preview": $"VBoxContainer/Control/VBoxContainer/HBoxContainer/SpritePreview"
}

##### PROCESSING #####
# Called when the node enters the scene tree for the first time.
func _ready():
	_init_items()

##### PUBLIC METHODS #####
func update_config(config: SpriteCustomizationResource) -> void:
	onready_paths.main_color.color = config.BODY_COLOR
	onready_paths.secondary_color.color = config.OUTLINE_COLOR
	onready_paths.sprite_preview.update_sprite(config)

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
	var body = _random_color()
	var outline = _random_color()
	var eyes_path = EYES_PATHS[randi_range(0, EYES_PATHS.size() - 1)]
	var mouth_path = MOUTHS_PATHS[randi_range(0, MOUTHS_PATHS.size() - 1)]
	onready_paths.main_color.color = body
	onready_paths.secondary_color.color = outline
	onready_paths.sprite_preview.update_body(body)
	onready_paths.sprite_preview.update_outline(outline)
	onready_paths.sprite_preview.update_eyes(load(eyes_path))
	onready_paths.sprite_preview.update_mouth(load(mouth_path))
	emit_signal("body_color_changed", body)
	emit_signal("outline_color_changed", outline)
	emit_signal("eyes_changed", eyes_path)
	emit_signal("mouth_changed", mouth_path)

func _on_main_color_picker_color_changed(color: Color) -> void:
	onready_paths.sprite_preview.update_body(color)
	emit_signal("body_color_changed", color)

func _on_secondary_color_picker_color_changed(color: Color) -> void:
	onready_paths.sprite_preview.update_outline(color)
	emit_signal("outline_color_changed", color)

func _on_eyes_edit_button_pressed() -> void:
	onready_paths.eyes_root.show()

func _on_mouth_edit_button_pressed() -> void:
	onready_paths.mouth_root.show()

func _on_eyes_items_item_activated(index: int) -> void:
	onready_paths.sprite_preview.update_eyes(load(EYES_PATHS[index]))
	onready_paths.eyes_root.hide()
	emit_signal("eyes_changed", EYES_PATHS[index])

func _on_eyes_close_button_pressed() -> void:
	onready_paths.eyes_root.hide()

func _on_mouth_items_item_activated(index: int) -> void:
	onready_paths.sprite_preview.update_mouth(load(MOUTHS_PATHS[index]))
	onready_paths.mouth_root.hide()
	emit_signal("mouth_changed", MOUTHS_PATHS[index])

func _on_mouth_close_button_pressed() -> void:
	onready_paths.mouth_root.hide()
