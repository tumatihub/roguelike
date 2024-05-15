class_name Interactor
extends Node

var current_interactable: Interactable

func _on_interactor_area_entered(area: Area2D) -> void:
	var parent := area.get_parent() as Interactable
	if parent != null:
		current_interactable = parent

func _on_interactor_area_exited(area: Area2D) -> void:
	var parent := area.get_parent() as Interactable
	if parent != null and parent == current_interactable:
		current_interactable = null

func _input(event: InputEvent) -> void:
	if current_interactable != null and Input.is_action_just_pressed("interact"):
		current_interactable.interact(self)
