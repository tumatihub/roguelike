class_name Recipes
extends PanelContainer

@export var _recipes: Array[RecipeData]
@export var _vbox: VBoxContainer
@export var _recipe_row_scene: PackedScene
@export var _inventory_data: InventoryData

func give_focus() -> void:
	_update()

func _update() -> void:
	_clear()
	var gave_focus := false
	for recipe_data in _recipes:
		var row := _recipe_row_scene.instantiate() as RecipeRow
		_vbox.add_child(row)
		row.update(recipe_data, _inventory_data)
		if not gave_focus:
			row.give_focus()
			gave_focus = true
		row.crafted.connect(_on_crafted)

func _clear() -> void:
	for child in _vbox.get_children():
		child.queue_free()

func _on_crafted(recipe_data: RecipeData) -> void:
	for recipe_slot_data in recipe_data.required_items:
		_inventory_data.remove_item_quantity(recipe_slot_data.item_data, recipe_slot_data.quantity)
	var crafted_item := SlotData.new()
	crafted_item.item_data = recipe_data.crafted_item
	crafted_item.quantity = 1
	_inventory_data.try_add_item(crafted_item)
	_update()
