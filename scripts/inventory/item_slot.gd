class_name ItemSlot
extends PanelContainer

@export var _texture: TextureRect
@export var _quantity_label: Label

var _out_focus_color: Color

func _ready() -> void:
	_out_focus_color = modulate

func update(slot_data: SlotData) -> void:
	_texture.texture = slot_data.item_data.texture
	_texture.show()
	_quantity_label.text = "x%d" % [slot_data.quantity]
	_quantity_label.show()


func _on_focus_entered() -> void:
	modulate = Color.WHITE


func _on_focus_exited() -> void:
	modulate = _out_focus_color
