extends "res://addons/gut/test.gd"

##### VARIABLES #####
#---- VARIABLES -----
var tab
var body_color_changed_times_called := 0
var body_color_changed_args := []
var outline_color_changed_times_called := 0
var outline_color_changed_args := []
var eyes_changed_times_called := 0
var eyes_changed_args := []
var eyes_color_changed_times_called := 0
var eyes_color_changed_args := []
var mouth_changed_times_called := 0
var mouth_changed_args := []
var mouth_color_changed_times_called := 0
var mouth_color_changed_args := []

##### SETUP #####
func before_each():
	tab = load("res://Scenes/UI/PlayerCustomizationMenu/PlayerCustomizationMenu/player_customization_tab.tscn").instantiate()
	add_child_autofree(tab)
	await wait_for_signal(tab.tree_entered, 0.1)
	body_color_changed_times_called = 0
	body_color_changed_args = []
	outline_color_changed_times_called = 0
	outline_color_changed_args = []
	eyes_changed_times_called = 0
	eyes_changed_args = []
	eyes_color_changed_times_called = 0
	eyes_color_changed_args = []
	mouth_changed_times_called = 0
	mouth_changed_args = []
	mouth_color_changed_times_called = 0
	mouth_color_changed_args = []

##### TESTS #####
func test_init():
	# given
	# when
	tab._init()
	# then
	assert_gt(tab._eyes_paths.size(), 0)
	assert_gt(tab._mouth_paths.size(), 0)

func test_ready():
	# given
	tab._eyes_paths = ["res://icon.svg"]
	tab._mouth_paths = ["res://icon.svg"]
	# when
	tab._ready()
	# then
	assert_eq(tab.onready_paths.eyes_items.item_count, 1)
	assert_eq(tab.onready_paths.mouth_items.item_count, 1)

func test_update_config():
	# given
	var sprite_preview = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(sprite_preview, "update_sprite").to_do_nothing()
	var config = SpriteCustomizationResource.new()
	config.BODY_COLOR = Color.OLD_LACE
	config.OUTLINE_COLOR = Color.GAINSBORO
	config.EYES_COLOR = Color.WEB_GRAY
	config.MOUTH_COLOR = Color.HONEYDEW
	tab.onready_paths.sprite_preview = sprite_preview
	# when
	tab.update_config(config)
	# then
	assert_eq(tab.onready_paths.main_color.color, Color.OLD_LACE)
	assert_eq(tab.onready_paths.secondary_color.color, Color.GAINSBORO)
	assert_eq(tab.onready_paths.eyes_color.color, Color.WEB_GRAY)
	assert_eq(tab.onready_paths.mouth_color.color, Color.HONEYDEW)
	assert_called(sprite_preview, "update_sprite", [config])

# load eyes paths, mouth paths, init items, init item list already tested with init/ready

func test_random_color():
	# given
	# when
	var res = tab._random_color()
	# then
	assert_not_null(res)

func test_on_randomize_button_pressed():
	# given
	tab._eyes_paths = ["res://icon.svg"]
	tab._mouth_paths = ["res://icon.svg"]
	var sprite_preview = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(sprite_preview, "update_body").to_do_nothing()
	stub(sprite_preview, "update_outline").to_do_nothing()
	stub(sprite_preview, "update_eyes").to_do_nothing()
	stub(sprite_preview, "update_eyes_color").to_do_nothing()
	stub(sprite_preview, "update_mouth").to_do_nothing()
	stub(sprite_preview, "update_mouth_color").to_do_nothing()
	tab.onready_paths.sprite_preview = sprite_preview
	tab.connect("body_color_changed", _on_body_color_changed)
	tab.connect("outline_color_changed", _on_outline_color_changed)
	tab.connect("eyes_changed", _on_eyes_changed)
	tab.connect("eyes_color_changed", _on_eyes_color_changed)
	tab.connect("mouth_changed", _on_mouth_changed)
	tab.connect("mouth_color_changed", _on_mouth_color_changed)
	# when
	tab._on_randomize_button_pressed()
	# then
	assert_called(sprite_preview, "update_body")
	assert_called(sprite_preview, "update_outline")
	assert_called(sprite_preview, "update_eyes")
	assert_called(sprite_preview, "update_eyes_color")
	assert_called(sprite_preview, "update_mouth")
	assert_called(sprite_preview, "update_mouth_color")
	assert_eq(body_color_changed_times_called, 1)
	assert_eq(outline_color_changed_times_called, 1)
	assert_eq(eyes_changed_times_called, 1)
	assert_eq(eyes_color_changed_times_called, 1)
	assert_eq(mouth_changed_times_called, 1)
	assert_eq(mouth_color_changed_times_called, 1)

func test_on_main_color_picker_color_changed():
	# given
	var sprite_preview = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(sprite_preview, "update_body").to_do_nothing()
	tab.onready_paths.sprite_preview = sprite_preview
	tab.connect("body_color_changed", _on_body_color_changed)
	# when
	tab._on_main_color_picker_color_changed(Color.RED)
	# then
	assert_called(sprite_preview, "update_body", [Color.RED])
	assert_eq(body_color_changed_times_called, 1)
	assert_eq(body_color_changed_args, [[Color.RED]])
	
func test_on_secondary_color_picker_color_changed():
	# given
	var sprite_preview = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(sprite_preview, "update_outline").to_do_nothing()
	tab.onready_paths.sprite_preview = sprite_preview
	tab.connect("outline_color_changed", _on_outline_color_changed)
	# when
	tab._on_secondary_color_picker_color_changed(Color.RED)
	# then
	assert_called(sprite_preview, "update_outline", [Color.RED])
	assert_eq(outline_color_changed_times_called, 1)
	assert_eq(outline_color_changed_args, [[Color.RED]])

func test_on_eyes_edit_button_pressed():
	# given
	tab.onready_paths.eyes_root.hide()
	# when
	tab._on_eyes_edit_button_pressed()
	# then
	assert_true(tab.onready_paths.eyes_root.visible)

func test_on_mouth_edit_button_pressed():
	# given
	tab.onready_paths.mouth_root.hide()
	# when
	tab._on_mouth_edit_button_pressed()
	# then
	assert_true(tab.onready_paths.mouth_root.visible)

func test_on_eyes_items_item_activated():
	# given
	var sprite_preview = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(sprite_preview, "update_eyes").to_do_nothing()
	tab._eyes_paths = ["res://icon.svg"]
	tab.onready_paths.sprite_preview = sprite_preview
	tab.onready_paths.eyes_root.show()
	tab.connect("eyes_changed", _on_eyes_changed)
	# when
	tab._on_eyes_items_item_activated(0)
	# then
	assert_called(sprite_preview, "update_eyes")
	assert_false(tab.onready_paths.eyes_root.visible)
	assert_eq(eyes_changed_times_called, 1)
	assert_eq(eyes_changed_args, [["res://icon.svg"]])

func test_on_eyes_close_button_pressed():
	# given
	tab.onready_paths.eyes_root.show()
	# when
	tab._on_eyes_close_button_pressed()
	# then
	assert_false(tab.onready_paths.eyes_root.visible)

func test_on_mouth_items_item_activated():
	# given
	var sprite_preview = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(sprite_preview, "update_mouth").to_do_nothing()
	tab._mouth_paths = ["res://icon.svg"]
	tab.onready_paths.sprite_preview = sprite_preview
	tab.onready_paths.mouth_root.show()
	tab.connect("mouth_changed", _on_mouth_changed)
	# when
	tab._on_mouth_items_item_activated(0)
	# then
	assert_called(sprite_preview, "update_mouth")
	assert_false(tab.onready_paths.mouth_root.visible)
	assert_eq(mouth_changed_times_called, 1)
	assert_eq(mouth_changed_args, [["res://icon.svg"]])

func test_on_mouth_close_button_pressed():
	# given
	tab.onready_paths.mouth_root.show()
	# when
	tab._on_mouth_close_button_pressed()
	# then
	assert_false(tab.onready_paths.mouth_root.visible)

func test_on_eyes_color_picker_button_color_changed():
	# given
	var sprite_preview = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(sprite_preview, "update_eyes_color").to_do_nothing()
	tab.onready_paths.sprite_preview = sprite_preview
	tab.connect("eyes_color_changed", _on_eyes_color_changed)
	# when
	tab._on_eyes_color_picker_button_color_changed(Color.RED)
	# then
	assert_called(sprite_preview, "update_eyes_color", [Color.RED])
	assert_eq(eyes_color_changed_times_called, 1)
	assert_eq(eyes_color_changed_args, [[Color.RED]])

func test_on_mouth_color_picker_button_color_changed():
	# given
	var sprite_preview = double(load("res://Scenes/UI/PlayerCustomizationMenu/PlayerSprite/player_sprite.gd")).new()
	stub(sprite_preview, "update_mouth_color").to_do_nothing()
	tab.onready_paths.sprite_preview = sprite_preview
	tab.connect("mouth_color_changed", _on_mouth_color_changed)
	# when
	tab._on_mouth_color_picker_button_color_changed(Color.RED)
	# then
	assert_called(sprite_preview, "update_mouth_color", [Color.RED])
	assert_eq(mouth_color_changed_times_called, 1)
	assert_eq(mouth_color_changed_args, [[Color.RED]])

##### UTILS #####
func _on_mouth_color_changed(color: Color) -> void:
	mouth_color_changed_times_called += 1
	mouth_color_changed_args.append([color])

func _on_mouth_changed(path: String) -> void:
	mouth_changed_times_called += 1
	mouth_changed_args.append([path])

func _on_eyes_color_changed(color: Color) -> void:
	eyes_color_changed_times_called += 1
	eyes_color_changed_args.append([color])

func _on_eyes_changed(path: String) -> void:
	eyes_changed_times_called += 1
	eyes_changed_args.append([path])

func _on_outline_color_changed(color: Color) -> void:
	outline_color_changed_times_called += 1
	outline_color_changed_args.append([color])

func _on_body_color_changed(color: Color) -> void:
	body_color_changed_times_called += 1
	body_color_changed_args.append([color])