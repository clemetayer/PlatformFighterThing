extends HBoxContainer
# handles the splitter contact counter visuals

##### VARIABLES #####
#---- EXPORTS -----
@export var texture : Texture

##### PUBLIC METHODS #####
func init(amount : int) -> void:
	for circle_idx in range(amount):
		var texture_rect = TextureRect.new()
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		texture_rect.texture = texture
		add_child(texture_rect)

func remove_circle() -> void:
	if get_child_count() > 0:
		get_child(0).queue_free()
