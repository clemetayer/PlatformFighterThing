extends ColorRect
# simple script to manipulate the pin cushion effect with tweens

##### VARIABLES #####
#---- CONSTANTS -----
const SHADER_DISTORTION_PARAM_NAME := "DISTORTION"
const FIRST_BUMP_TIME := 0.125
const RESET_EFFECT_VALUE := 1.0
const MAX_EFFECT_VALUE := 1.5
const MIN_EFFECT_VALUE := 0.5

##### PUBLIC METHODS #####
func play_animation(duration : float) -> void:
	var tween = create_tween()
	tween.tween_method(_update_material_val,RESET_EFFECT_VALUE,MAX_EFFECT_VALUE,FIRST_BUMP_TIME / 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	await tween.finished
	tween = create_tween()
	tween.tween_method(_update_material_val,MAX_EFFECT_VALUE,MIN_EFFECT_VALUE,FIRST_BUMP_TIME / 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	await tween.finished
	tween = create_tween()
	tween.tween_method(_update_material_val,MIN_EFFECT_VALUE,RESET_EFFECT_VALUE,abs(duration - FIRST_BUMP_TIME)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

##### PROTECTED METHODS #####
func _update_material_val(value : float) -> void:
	material.set_shader_parameter(SHADER_DISTORTION_PARAM_NAME,value)
