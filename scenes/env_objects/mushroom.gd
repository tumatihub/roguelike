extends Node2D

@export var interactable: Interactable

func _ready() -> void:
	interactable.interacted.connect(_on_interact)

func _on_interact(interactor: Interactor) -> void:
	print("%s just got a Brown Mushroom!" % [interactor.owner.name])
	queue_free()
