class_name InventoryData
extends Resource

signal updated
signal equipped_item(item_data: ItemData)
signal equipped_weapon(slot_data: SlotData)
signal unequipped_weapon(slot_data: SlotData)

@export var slot_datas: Array[SlotData]

var current_equipped_item: ItemData
var current_equipped_weapon: SlotData

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
	if current_equipped_weapon:
		unequip_weapon()
	current_equipped_weapon = slot_data
	if not current_equipped_weapon.weapon_instance:
		var instance := current_equipped_weapon.item_data.weapon_scene.instantiate() as Weapon
		current_equipped_weapon.weapon_instance = instance
		current_equipped_weapon.weapon_instance.slot_data = slot_data
		current_equipped_weapon.weapon_instance.weapon_broke.connect(_on_weapon_broke)
	equipped_weapon.emit(slot_data)

func unequip_weapon() -> void:
	unequipped_weapon.emit(current_equipped_weapon)
	current_equipped_weapon = null

func get_item_quantity(item_data: ItemData) -> int:
	var quantity := 0
	for slot in slot_datas:
		if slot and slot.item_data == item_data:
			quantity += slot.quantity
	return quantity

func remove_item_quantity(item_data: ItemData, quantity: int) -> void:
	var qty := quantity
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].item_data == item_data:
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

func has_available_slot() -> bool:
	for slot in slot_datas:
		if slot == null:
			return true
	return false

func _on_weapon_broke(slot_data: SlotData) -> void:
	print("Broke")
	unequip_weapon()
	for index in slot_datas.size():
		if slot_datas[index] == slot_data:
			slot_datas[index] = null
			updated.emit()
			slot_data.weapon_instance.queue_free()
			break
