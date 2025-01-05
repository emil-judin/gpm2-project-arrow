extends Node
class_name InventoryUi

signal dropped_item(item: Item, drop_position: Vector2)

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
			primary_inventory_icons[i].set_icon_texture(GameState.primary_inventory[i].get_texture())
		else:
			primary_inventory_icons[i].set_icon_texture(null)
		
	for i in secondary_inventory_icons.size() - 1:
		if i < GameState.secondary_inventory.size() && GameState.secondary_inventory[i] != null:
			secondary_inventory_icons[i].texture = GameState.secondary_inventory[i].get_texture()
		else:
			secondary_inventory_icons[i].texture = null

func reset_inventory_ui():
	for i in GameState.primary_inventory.size() - 1:
		primary_inventory_icons[i].set_icon_texture(null)
		
	for i in GameState.secondary_inventory.size() - 1:
		secondary_inventory_icons[i].texture = null

func drag_and_dropped_item(index: int, drop_position: Vector2):
	dropped_item.emit(GameState.primary_inventory[index], drop_position)
