class_name ItemSlot
extends PanelContainer

signal equiped(slot_data: SlotData)
signal dropped(slot_data: SlotData)

@export var _texture: TextureRect
@export var _quantity_label: Label

var _out_focus_color: Color
var _slot_data: SlotData

func _ready() -> void:
	_out_focus_color = self_modulate

func update(slot_data: SlotData) -> void:
	_slot_data = slot_data
	_texture.texture = slot_data.item_data.texture
	_texture.show()
	_quantity_label.text = "x%d" % [slot_data.quantity]
	_quantity_label.show()


func _input(event: InputEvent) -> void:
	if not has_focus() or _slot_data == null:
		return
	if Input.is_action_just_pressed("use_item"):
		if _slot_data.item_data.type != ItemData.Type.COMMON:
			equiped.emit(_slot_data)
	if Input.is_action_just_pressed("interact"):
		dropped.emit(_slot_data)


func _on_focus_entered() -> void:
	self_modulate = Color.WHITE


func _on_focus_exited() -> void:
	self_modulate = _out_focus_color
