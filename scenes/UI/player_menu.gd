class_name PlayerMenu
extends TabContainer

signal toggle_visibility(is_visible: bool)

@export var _inventory: Inventory

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		visible = !visible
		toggle_visibility.emit(visible)
		if visible:
			set_current_tab(0)

func _on_tab_selected(tab: int) -> void:
	match tab:
		0: _inventory.give_focus()


