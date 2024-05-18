class_name RecipeRow
extends HBoxContainer

signal crafted(recipe_data)

const INVENTORY_FULL = "Inventory is full"
const NOT_ENOUGH_ITEMS = "Not enough items"

@export var _crafted_item_texture: TextureRect
@export var _h_flow: HFlowContainer
@export var _recipe_slot_scene: PackedScene
@export var _button: Button
@export var _fail_text_label: Label
@export var _name_label: Label

var _recipe_data: RecipeData

func update(recipe_data: RecipeData, inventory_data: InventoryData) -> void:
	_recipe_data = recipe_data
	var can_craft := true
	var fail_text: String
	_crafted_item_texture.texture = recipe_data.crafted_item.texture
	_name_label.text = recipe_data.crafted_item.item_name
	for recipe_slot_data in recipe_data.required_items:
		var slot := _recipe_slot_scene.instantiate() as RecipeSlot
		_h_flow.add_child(slot)
		slot.update(recipe_slot_data)
		var available := inventory_data.get_item_quantity(recipe_slot_data.item_data)
		if available < recipe_slot_data.quantity:
			slot.disable()
			can_craft = false
			fail_text = NOT_ENOUGH_ITEMS
	if not inventory_data.has_available_slot():
		can_craft = false
		fail_text = INVENTORY_FULL
	if not can_craft:
		_button.disabled = true
		_fail_text_label.text = fail_text

func give_focus() -> void:
	grab_focus()

func _on_craft_pressed() -> void:
	crafted.emit(_recipe_data)

func _on_focus_entered() -> void:
	print("row in focus")
