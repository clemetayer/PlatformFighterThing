extends Control

# ai selection menu

##### SIGNALS #####
signal close_triggered
signal preset_selected(preset: PlayerConfig)

##### VARIABLES #####
#---- STANDARD -----
#==== ONREADY ====
@onready var onready_paths := {
	"presets": $"AIPresetSelectionMenu",
	"visualisation": $"AIVisualisation",
}


##### PUBLIC METHODS #####
func open() -> void:
	onready_paths.presets.show()
	onready_paths.visualisation.hide()


##### SIGNAL MANAGEMENT #####
func _on_ai_preset_selection_menu_preset_selected(preset: PlayerConfig) -> void:
	onready_paths.visualisation.update_ai(preset)
	onready_paths.presets.hide()
	onready_paths.visualisation.show()
	preset_selected.emit(preset)


func _on_ai_visualisation_close_triggered() -> void:
	close_triggered.emit()


func _on_ai_visualisation_show_ai_presets_triggered() -> void:
	onready_paths.presets.show()
	onready_paths.visualisation.hide()
