extends Node

@export var mouse: Node2D

func _ready():
	mouse.visible = GameState.mouse

func clicked(viewport: Node, event: InputEvent, shape_idx: int):
	if event.is_action_pressed("primary_click") && GameState.primary_inventory.size() > 0:
		GameState.mouse = true
		mouse.visible = true
		GameState.remove_item_from_inventory(GameState.primary_inventory[0])
