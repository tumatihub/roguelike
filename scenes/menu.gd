extends Node2D

@export var game_scene: PackedScene

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)


func _on_quit_pressed() -> void:
	get_tree().quit()
