extends Node2D

@export var _interactable: Interactable
@export var _opened_sprite: Sprite2D
@export var _closed_sprite: Sprite2D

var _closed := true

func _ready() -> void:
	_interactable.interacted.connect(_on_interacted)

func _on_interacted(interactor: Interactor) -> void:
	if not _closed:
		return
	_closed = false
	_opened_sprite.visible = true
	_closed_sprite.visible = false
	_interactable.disable_interaction()
	print("%s opened the %s" % [interactor.owner.name, name])
