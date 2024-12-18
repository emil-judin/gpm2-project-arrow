extends Node
class_name ItemManager

signal inventory_updated()

var items_in_scene: Array[Item] = [] # TODO: Save this to scene class

func _ready():
	_on_items_updated()

func get_item_at_position(position):
	for item in items_in_scene:
		if item.is_position_on_item(position):
			print("Clicked on item %s" % item.id)
			return item

func handle_pick_up(item: Item):
	if item.is_collectible:
		collect_item(item)

func handle_drop(item: Item, position: Vector2):
	if item.is_droppable:
		drop_item(item, position)

func collect_item(item: Item):
	print("Adding item: %s" % item.item_name)
	GameState.add_item_to_inventory(item)
	items_in_scene.erase(item)
	item.get_parent().remove_child(item)
	inventory_updated.emit()
	
func drop_item(item: Item, position: Vector2):
	# TODO: selection with green and red selector
	print("Dropping item: %s" % item.item_name)
	GameState.remove_item_from_inventory(item)
	items_in_scene.append(item)
	GameState.collected_item_ids.erase(item.id)
	get_tree().root.add_child(item)
	item.global_position = position
	inventory_updated.emit()

func _on_items_updated():
	var item_nodes = get_tree().get_nodes_in_group("items")
	var all_items = []
	all_items.assign(item_nodes)
	for item in all_items:
		if GameState.has_collected(item):
			item.queue_free()
		else:
			items_in_scene.append(item)
