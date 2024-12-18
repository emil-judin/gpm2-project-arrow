extends Node

@export var mouseitem: Node2D
@export var pc_area: Node2D
@export var spawned_mouse: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	spawned_mouse.visible = GameState.computer_active
	mouseitem.visible = GameState.mouse
	if spawned_mouse.visible:
		pc_area.enable_computer()


func clicked(viewport: Node, event: InputEvent, shape_idx: int):
	if event.is_action_pressed("primary_click") && GameState.primary_inventory.size() > 0:
		GameState.computer_active = true
		pc_area.enable_computer()
		GameState.remove_item_from_inventory(GameState.primary_inventory[0])
		spawned_mouse.visible = true
		GameState.mouse = false
