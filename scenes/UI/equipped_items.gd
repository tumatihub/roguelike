extends Control

@export var _weapon_texture: TextureRect
@export var _weapon_durability_label: Label
@export var _item_texture: TextureRect
@export var _item_quantity_label: Label

@export var _inventory_data: InventoryData

func _ready() -> void:
	_inventory_data.equipped_item.connect(_on_equipped_item)
	_inventory_data.equipped_weapon.connect(_on_equipped_weapon)
	_inventory_data.updated.connect(_on_inventory_updated)

func _clear_item() -> void:
	_item_texture.texture = null
	_item_quantity_label.text = ""

func _on_equipped_item(item_data: ItemData) -> void:
	_item_texture.texture = item_data.texture
	_item_quantity_label.text = "x%d" % [_inventory_data.get_item_quantity(item_data)]

func _on_equipped_weapon(item_data: ItemData) -> void:
	pass

func _on_inventory_updated() -> void:
	if _inventory_data.current_equipped_item:
		var quantity := _inventory_data.get_item_quantity(_inventory_data.current_equipped_item)
		if quantity > 0:
			_item_quantity_label.text = "x%d" % [quantity]
		else:
			_inventory_data.current_equipped_item = null
			_clear_item()
