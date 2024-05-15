class_name Interactable
extends Node

signal interacted(interactor: Interactor)

@export var _interaction_text: String

@onready var _label: Label = %Label as Label

var _current_interactor: Interactor
var _can_interact := true

func _ready() -> void:
	_label.text = _interaction_text

func disable_interaction() -> void:
	_label.visible = false
	_can_interact = false

func _on_interactable_area_entered(area: Area2D) -> void:
	if not _can_interact:
		return
	var parent := area.get_parent() as Interactor
	if parent != null:
		_label.visible = true
		_current_interactor = parent

func _on_interactable_area_exited(area: Area2D) -> void:
	var parent := area.get_parent() as Interactor
	if parent != null and parent == _current_interactor:
		_label.visible = false
		_current_interactor = null

func interact(interactor: Interactor) -> void:
	interacted.emit(interactor)
