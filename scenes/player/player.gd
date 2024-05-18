class_name Player
extends CharacterBody2D

@export var _speed: float = 100
@export var _body: AnimatedSprite2D
@export var _weapon: Weapon
@export var _camera_2d: Camera2D
@export var _inventory_data: InventoryData
@export var _hittable: Hittable
@export var _weapon_handle: Node2D

var _x: float
var _y: float
var _can_move := true

func _ready() -> void:
	_inventory_data.equipped_weapon.connect(_on_weapon_equipped)
	_inventory_data.unequipped_weapon.connect(_on_weapon_unequipped)
	var player_menu = get_tree().get_first_node_in_group("player_menu") as PlayerMenu
	if player_menu:
		player_menu.toggle_visibility.connect(_on_toggle_player_menu_visibility)

func try_receiving_item(slot_data: SlotData) -> bool:
	return _inventory_data.try_add_item(slot_data)

func _process(delta: float) -> void:
	if velocity.length() > 0:
		_body.play("run")
	else:
		_body.play("idle")

func _physics_process(_delta: float) -> void:
	if not _can_move:
		return
	velocity = Vector2(_x, _y).normalized() * _speed * 1/_camera_2d.zoom
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if not _can_move:
		return
	
	_x = Input.get_axis("left", "right")
	_y = Input.get_axis("up", "down")
	
	if _x < 0:
		_body.scale.x = -1
	elif _x > 0:
		_body.scale.x = 1
		
	if Input.is_action_pressed("attack") and _weapon:
		_weapon.attack()

	if Input.is_action_just_pressed("use_item") and _inventory_data.current_equipped_item:
		_hittable.heal(_inventory_data.current_equipped_item.heal_amount)
		_inventory_data.remove_item_quantity(_inventory_data.current_equipped_item, 1)

func _on_toggle_player_menu_visibility(is_visible: bool) -> void:
	_can_move = !is_visible

func _on_weapon_equipped(slot_data: SlotData) -> void:
	_weapon = slot_data.weapon_instance
	if not _weapon.get_parent():
		_weapon_handle.add_child(_weapon)

func _on_weapon_unequipped(slot_data: SlotData) -> void:
	_weapon = null
