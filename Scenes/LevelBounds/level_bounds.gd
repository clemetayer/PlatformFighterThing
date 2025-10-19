extends Area2D
# level bounds script

##### SIGNAL MANAGEMENT #####
func _on_body_exited(body: Node2D) -> void:
	if GroupUtils.is_player(body):
		body.rpc("kill")
