class_name SlotData
extends Resource

const MAX_SLOT = 20

@export var item_data: ItemData
@export_range(1, MAX_SLOT) var quantity: int = 1:
	set(value):
		if value > MAX_SLOT:
			push_error("SlotData can't have quantity above %d" % [MAX_SLOT])
		else:
			quantity = value

func try_merge(slot_data: SlotData) -> bool:
	if not item_data.stackable:
		return false
	if slot_data.quantity + quantity > MAX_SLOT:
		return false
	quantity += slot_data.quantity
	return true
