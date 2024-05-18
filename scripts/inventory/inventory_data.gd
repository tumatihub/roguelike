class_name InventoryData
extends Resource

signal updated
signal equipped_item(item_data: ItemData)
signal equipped_weapon(item_data: ItemData)

@export var slot_datas: Array[SlotData]

var current_equipped_item: ItemData
var current_equipped_weapon: ItemData

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

func equip_item(slot_data: SlotData) -> void:
	current_equipped_item = slot_data.item_data
	equipped_item.emit(slot_data.item_data)

func equip_weapon(slot_data: SlotData) -> void:
	current_equipped_weapon = slot_data.item_data
	equipped_weapon.emit(slot_data.item_data)

func get_item_quantity(item_data: ItemData) -> int:
	var quantity := 0
	for slot in slot_datas:
		if slot and slot.item_data == item_data:
			quantity += slot.quantity
	return quantity

func remove_item_quantity(item_data: ItemData, quantity: int) -> void:
	var qty := quantity
	for index in slot_datas.size():
		if slot_datas[index].item_data == item_data:
			var remaining := slot_datas[index].quantity - qty
			if remaining > 0:
				slot_datas[index].quantity = remaining
				updated.emit()
				return
			else:
				qty -= slot_datas[index].quantity
				slot_datas[index] = null
			if qty == 0:
				break
	updated.emit()
