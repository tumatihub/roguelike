class_name InventoryData
extends Resource

signal updated

@export var slot_datas: Array[SlotData]

func try_add_item(slot_data: SlotData) -> bool:
	for index in slot_datas.size():
		if slot_datas[index] == null:
			slot_datas[index] = slot_data.duplicate()
			updated.emit()
			return true
		elif slot_datas[index].item_data == slot_data.item_data:
			if slot_datas[index].try_merge(slot_data):
				updated.emit()
				return true
	return false

