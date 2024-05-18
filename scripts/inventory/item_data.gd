class_name ItemData
extends Resource

enum Type {
	COMMON,
	CONSUMABLE,
	WEAPON
}

@export var texture: Texture2D
@export var item_name: String
@export_multiline var description: String
@export var stackable := true
@export var type := Type.COMMON

@export var heal_amount := 0
@export var weapon_scene: PackedScene
