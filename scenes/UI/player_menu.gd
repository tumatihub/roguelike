class_name PlayerMenu
extends TabContainer

signal toggle_visibility(is_visible: bool)

@export var _inventory: Inventory
@export var _recipes: Recipes

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		visible = !visible
		toggle_visibility.emit(visible)
		if visible:
			set_current_tab(0)
	if visible:
		if Input.is_action_just_pressed("next_tab"):
			select_next_available()
		elif Input.is_action_just_pressed("previous_tab"):
			select_previous_available()
		
func _on_tab_selected(tab: int) -> void:
	match tab:
		0: _inventory.give_focus()
		1: _recipes.give_focus()


