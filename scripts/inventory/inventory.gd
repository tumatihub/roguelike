class_name Inventory
extends PanelContainer

@export var _inventory_data: InventoryData
@export var _grid_container: GridContainer
@export var _item_slot_scene: PackedScene

func _ready() -> void:
	_update_inventory()
	_inventory_data.updated.connect(_update_inventory)
	_grid_container.focus_entered.connect(_on_grid_focus_entered)

func give_focus() -> void:
	var child = _grid_container.get_child(0) as ItemSlot
	if child:
		child.grab_focus()
	
func _update_inventory() -> void:
	for child in _grid_container.get_children():
		child.queue_free()
	for slot_data in _inventory_data.slot_datas:
		var item_slot = _item_slot_scene.instantiate() as ItemSlot
		_grid_container.add_child(item_slot)
		if slot_data:
			item_slot.update(slot_data)

func _on_focus_entered() -> void:
	print("Inventory in focus")

func _on_grid_focus_entered() -> void:
	print("Grid in focus")
