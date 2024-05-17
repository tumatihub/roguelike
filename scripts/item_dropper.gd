class_name ItemDropper
extends Node2D

@export var item_drop_scene: PackedScene

func drop() -> void:
	var item_drop := item_drop_scene.instantiate() as Node2D
	get_tree().root.add_child.call_deferred(item_drop)
	item_drop.global_position = global_position
