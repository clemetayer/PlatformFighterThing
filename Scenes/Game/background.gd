extends Node
# Manages the background of a game

##### PUBLIC METHODS #####
func add_background(background_path : String) -> void:
	reset()
	_spawn_background(background_path)

func reset() -> void:
	for c in get_children():
		c.queue_free()

##### PROTECTED METHODS #####
func _spawn_background(background_path : String) -> void:
	var background = load(background_path).instantiate()
	add_child(background)
