extends Area2D
# level bounds script

##### SIGNAL MANAGEMENT #####
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.rpc("kill")
