extends MarginContainer
# handles the menu to configure the player appearance

##### SIGNALS #####
signal body_color_changed(new_color: Color)
signal outline_color_changed(new_color: Color)
signal eyes_changed(eyes_image_path: String)
signal eyes_color_changed(eyes_color: Color)
signal mouth_changed(mouth_image_path: String)
signal mouth_color_changed(mouth_color: Color)

##### VARIABLES #####
#---- CONSTANTS -----
const EYES_PATHS_FOLDER := "res://Scenes/Player/Eyes/"
const MOUTH_PATHS_FOLDER := "res://Scenes/Player/Mouths/"
const VALID_IMAGE_EXTENSION := ".PNG"

#==== PRIVATE ====
var _eyes_paths := []
var _mouth_paths := []

#==== ONREADY ====
@onready var onready_paths := {
	"main_color": $"VBoxContainer/Control/VBoxContainer/HBoxContainer/VBoxContainer/Elements/Buttons/MainColorPicker",
	"secondary_color": $"VBoxContainer/Control/VBoxContainer/HBoxContainer/VBoxContainer/Elements/Buttons/SecondaryColorPicker",
	"eyes_root": $"VBoxContainer/Control/Eyes",
	"eyes_color": $"VBoxContainer/Control/VBoxContainer/HBoxContainer/VBoxContainer/Elements/Buttons/Eyes/EyesColorPickerButton",
	"eyes_items": $"VBoxContainer/Control/Eyes/EyesItems",
	"mouth_root": $"VBoxContainer/Control/Mouth",
	"mouth_color": $"VBoxContainer/Control/VBoxContainer/HBoxContainer/VBoxContainer/Elements/Buttons/Mouth/MouthColorPickerButton",
	"mouth_items": $"VBoxContainer/Control/Mouth/MouthItems",
	"sprite_preview": $"VBoxContainer/Control/VBoxContainer/HBoxContainer/SpritePreview"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	_load_eyes_paths()
	_load_mouth_paths()

# Called when the node enters the scene tree for the first time.
func _ready():
	_init_items()

##### PUBLIC METHODS #####
func update_config(config: SpriteCustomizationResource) -> void:
	onready_paths.main_color.color = config.BODY_COLOR
	onready_paths.secondary_color.color = config.OUTLINE_COLOR
	onready_paths.eyes_color.color = config.EYES_COLOR
	onready_paths.mouth_color.color = config.MOUTH_COLOR
	onready_paths.sprite_preview.update_sprite(config)

##### PROTECTED METHODS #####
func _load_eyes_paths() -> void:
	_eyes_paths = StaticUtils.list_files_in_dir(EYES_PATHS_FOLDER) \
		.filter(func(file): return file.ends_with(VALID_IMAGE_EXTENSION)) \
		.map(func(file): return "%s%s" % [EYES_PATHS_FOLDER, file])

func _load_mouth_paths() -> void:
	_mouth_paths = StaticUtils.list_files_in_dir(MOUTH_PATHS_FOLDER) \
		.filter(func(file): return file.ends_with(VALID_IMAGE_EXTENSION)) \
		.map(func(file): return "%s%s" % [MOUTH_PATHS_FOLDER, file])

func _init_items() -> void:
	_init_item_list(onready_paths.eyes_items, _eyes_paths)
	_init_item_list(onready_paths.mouth_items, _mouth_paths)

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
	var eyes_path = _eyes_paths[randi_range(0, _eyes_paths.size() - 1)]
	var eyes_color = _random_color()
	var mouth_path = _mouth_paths[randi_range(0, _mouth_paths.size() - 1)]
	var mouth_color = _random_color()
	onready_paths.main_color.color = body
	onready_paths.secondary_color.color = outline
	onready_paths.eyes_color.color = eyes_color
	onready_paths.mouth_color.color = mouth_color
	onready_paths.sprite_preview.update_body(body)
	onready_paths.sprite_preview.update_outline(outline)
	onready_paths.sprite_preview.update_eyes(load(eyes_path))
	onready_paths.sprite_preview.update_eyes_color(eyes_color)
	onready_paths.sprite_preview.update_mouth(load(mouth_path))
	onready_paths.sprite_preview.update_mouth_color(mouth_color)
	emit_signal("body_color_changed", body)
	emit_signal("outline_color_changed", outline)
	emit_signal("eyes_changed", eyes_path)
	emit_signal("eyes_color_changed", eyes_color)
	emit_signal("mouth_changed", mouth_path)
	emit_signal("mouth_color_changed", mouth_color)

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
	onready_paths.sprite_preview.update_eyes(load(_eyes_paths[index]))
	onready_paths.eyes_root.hide()
	emit_signal("eyes_changed", _eyes_paths[index])

func _on_eyes_close_button_pressed() -> void:
	onready_paths.eyes_root.hide()

func _on_mouth_items_item_activated(index: int) -> void:
	onready_paths.sprite_preview.update_mouth(load(_mouth_paths[index]))
	onready_paths.mouth_root.hide()
	emit_signal("mouth_changed", _mouth_paths[index])

func _on_mouth_close_button_pressed() -> void:
	onready_paths.mouth_root.hide()

func _on_eyes_color_picker_button_color_changed(color: Color) -> void:
	onready_paths.sprite_preview.update_eyes_color(color)
	emit_signal("eyes_color_changed", color)

func _on_mouth_color_picker_button_color_changed(color: Color) -> void:
	onready_paths.sprite_preview.update_mouth_color(color)
	emit_signal("mouth_color_changed", color)
