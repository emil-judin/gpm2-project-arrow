extends Node
class_name InventoryUi

signal clicked_drop_item(item: Item)

@onready var primary_inventory_parent: Node = $PrimaryInventory
@onready var secondary_inventory_parent: Node = $SecondaryInventory
@onready var primary_inventory_icons: Array[TextureRect] = []
@onready var secondary_inventory_icons: Array[TextureRect] = []

func _ready():
	var primary_inventory_nodes = primary_inventory_parent.find_children("Item*", "TextureRect")
	primary_inventory_icons.assign(primary_inventory_nodes)
	var secondary_inventory_nodes = secondary_inventory_parent.find_children("Item*", "TextureRect")
	secondary_inventory_icons.assign(secondary_inventory_nodes)
	
	update_inventory_ui()

func update_inventory_ui():
	reset_inventory_ui()
	
	for i in primary_inventory_icons.size() - 1:
		if i < GameState.primary_inventory.size() && GameState.primary_inventory[i] != null:
			primary_inventory_icons[i].texture = GameState.primary_inventory[i].get_texture()
		else:
			primary_inventory_icons[i].texture = null
		
	for i in secondary_inventory_icons.size() - 1:
		if i < GameState.secondary_inventory.size() && GameState.secondary_inventory[i] != null:
			secondary_inventory_icons[i].texture = GameState.secondary_inventory[i].get_texture()
		else:
			secondary_inventory_icons[i].texture = null

func reset_inventory_ui():
	for i in GameState.primary_inventory.size() - 1:
		primary_inventory_icons[i].texture = null
		
	for i in GameState.secondary_inventory.size() - 1:
		secondary_inventory_icons[i].texture = null

func clicked_item_panel(event: InputEvent, index: int):
	if event.is_action_pressed("secondary_click"):
		if index < GameState.primary_inventory.size() && GameState.primary_inventory[index]:
			clicked_drop_item.emit(GameState.primary_inventory[index])
