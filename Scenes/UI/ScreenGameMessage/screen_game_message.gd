extends Control
# Displays a message at the center of the screen. supports bbcode

##### VARIABLES #####
#---- CONSTANTS -----
const ENTER_ANIM_TIME := 0.25
const EXIT_ANIM_TIME := 0.25

#---- STANDARD -----
#==== PRIVATE ====
var _display_characters_tween : Tween

#==== ONREADY ====
@onready var onready_paths : ={
	"label": $"RichTextLabel",
	"animation": $"AnimationPlayer"
}

##### PUBLIC METHODS #####
func init() -> void:
	onready_paths.label.text = ""

# displays a message on the screen for a specific duration (in seconds). There is also an option to try to display all the characters at once
func display_message(message : String, duration : float, display_all_characters : bool = false) -> void:
	var on_mid_screen_time = max(duration - (ENTER_ANIM_TIME + EXIT_ANIM_TIME),0.0)
	onready_paths.label.text = message
	onready_paths.animation.play("enter")
	if display_all_characters:
		onready_paths.label.visible_characters = -1
	else:
		onready_paths.label.visible_ratio = 0
		if _display_characters_tween != null:
			_display_characters_tween.kill()
		_display_characters_tween = create_tween()
		_display_characters_tween.tween_property(onready_paths.label,"visible_ratio",1.0,duration)
	await onready_paths.animation.animation_finished
	if on_mid_screen_time > 0:
		await get_tree().create_timer(on_mid_screen_time).timeout
	onready_paths.animation.play("exit")
