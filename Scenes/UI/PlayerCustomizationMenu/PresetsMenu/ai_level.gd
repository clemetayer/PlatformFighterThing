extends Label

# handles the level indicator for the AI

##### VARIABLES #####
#---- CONSTANTS -----
const AI_LEVEL_GRADIENT := preload("res://Scenes/UI/PlayerCustomizationMenu/PresetsMenu/ai_level_gradient.tres")
const MAX_LEVEL := 10.0
const LEVEL_TEXT := "%d"


##### PUBLIC METHODS #####
func set_level(level: int) -> void:
	text = LEVEL_TEXT % level
	modulate = AI_LEVEL_GRADIENT.gradient.sample(clamp(level / MAX_LEVEL, 0.0, 1.0))
