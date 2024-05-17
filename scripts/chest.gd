extends Node2D

@export var _interactable: Interactable
@export var _opened_sprite: Sprite2D
@export var _closed_sprite: Sprite2D
@export var _item_giver: ItemGiver

var _closed := true

func _ready() -> void:
	_item_giver.item_gave.connect(_on_item_gave)
	_item_giver.inventory_full.connect(_on_inventory_full)

func _on_item_gave() -> void:
	_closed = false
	_opened_sprite.visible = true
	_closed_sprite.visible = false
	_interactable.disable_interaction()

func _on_inventory_full() -> void:
	print("Inventory full")
