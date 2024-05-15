extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = body as Player
	if player == null:
		return
	print("Player got a mushroom")
