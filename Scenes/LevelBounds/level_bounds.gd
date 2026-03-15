extends Area2D

# level bounds script

##### PUBLIC METHODS #####
func get_collision_shape() -> CollisionShape2D:
	for child in get_children():
		if child is CollisionShape2D:
			return child
	return null


func get_bounds() -> Array:
	var collision = get_collision_shape()
	var col_pos = collision.get_global_position()
	return [
		col_pos - collision.shape.get_size() / 2.0,
		col_pos + collision.shape.get_size() / 2.0,
	]


##### SIGNAL MANAGEMENT #####
func _on_body_exited(body: Node2D) -> void:
	if GroupUtils.is_player(body):
		body.rpc("kill")
