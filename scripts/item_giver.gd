class_name ItemGiver
extends Node

signal item_gave
signal inventory_full

@export var _interactable: Interactable
@export var _slot_data: SlotData
@export_range(1, SlotData.MAX_SLOT) var _max_random_quantity: int = 1
@export_range(1, SlotData.MAX_SLOT) var _min_random_quantity: int = 1
@export var _is_random: bool = false

func _ready() -> void:
	if not _interactable:
		printerr("Missing interactable at %s" % [owner.name])
		return
	_interactable.interacted.connect(_on_interact)
	if _is_random:
		var new_slot := _slot_data.duplicate() as SlotData
		new_slot.quantity = randi_range(_min_random_quantity, _max_random_quantity)
		_slot_data = new_slot
	for child in get_children():
		if child is Label:
			child.text = str(_slot_data.quantity)
			child.global_position = owner.global_position

func _on_interact(interactor: Interactor) -> void:
	var player = interactor.owner as Player
	if not player:
		return
	if not player.try_receiving_item(_slot_data):
		print("Player inventory is full!!")
		inventory_full.emit()
		return
	print("Player got %d %s" % [_slot_data.quantity, _slot_data.item_data.item_name])
	item_gave.emit()
