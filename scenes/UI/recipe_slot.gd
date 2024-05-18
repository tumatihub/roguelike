class_name RecipeSlot
extends PanelContainer

@export var texture: TextureRect
@export var label: Label

func update(recipe_slot_data: RecipeSlotData) -> void:
	texture.texture = recipe_slot_data.item_data.texture
	label.text = str(recipe_slot_data.quantity)

func disable() -> void:
	modulate = Color.GRAY
