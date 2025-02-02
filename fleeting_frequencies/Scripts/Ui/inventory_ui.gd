extends Node
class_name InventoryUi

signal dropped_item(item: Item, drop_position: Vector2)
signal used_item(item: Item, interaction_target: Interaction)

@onready var primary_inventory_parent: Node = $PrimaryInventory
@onready var secondary_inventory_parent: Node = $SecondaryInventory
@onready var item_hint: ItemHint = $ItemHint
var primary_inventory_icons: Array[Drag] = []
var secondary_inventory_icons: Array[TextureRect] = []

func _ready():
	var primary_inventory_nodes = primary_inventory_parent.find_children("Item*", "Drag")
	primary_inventory_icons.assign(primary_inventory_nodes)
	for i in primary_inventory_icons.size() - 1:
		# connect signals
		primary_inventory_icons[i].dropped_item_icon.connect(dropped_item_icon)
		primary_inventory_icons[i].used_item_icon.connect(used_item_icon)
		primary_inventory_icons[i].hovered_item_icon.connect(enable_item_hint)
		primary_inventory_icons[i].unhovered_item_icon.connect(disable_item_hint)
	
	var secondary_inventory_nodes = secondary_inventory_parent.find_children("Item*", "TextureRect")
	secondary_inventory_icons.assign(secondary_inventory_nodes)
	
	update_inventory_ui()
	
	secondary_inventory_parent.visible = GameState.repaired_walkie_talkie

func enable_secondary_inventory():
	# TODO: play enable animation
	GameState.repaired_walkie_talkie = true
	secondary_inventory_parent.visible = true

func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array

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

func dropped_item_icon(index: int, drop_position: Vector2):
	dropped_item.emit(GameState.primary_inventory[index], drop_position)

func used_item_icon(index: int, interaction_target: Interaction):
	used_item.emit(GameState.primary_inventory[index], interaction_target)

func enable_item_hint(index: int):
	var item = GameState.primary_inventory[index]
	item_hint.show_item_hint(primary_inventory_icons[index].get_parent(), item.item_name, item.description)

func disable_item_hint():
	item_hint.hide_item_hint()
