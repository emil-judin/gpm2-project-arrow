extends Node
class_name ItemManager

signal inventory_updated()

@export var items_parent: Node

func _ready():
	initialize_items()

func initialize_items():
	# turn all items invisible on scene load
	var item_nodes = get_tree().get_nodes_in_group("items")
	var default_items: Array[Item] = []
	default_items.assign(item_nodes)
	for item in default_items:
		item.visible = false
	
	# get items entry from GameState for current scene
	var items_in_scene = get_items_in_current_scene()
	if items_in_scene == null:
		# no entry for current scene load default items in group
		set_items_in_current_scene(default_items)
		for item in default_items:
			item.visible = true
	else:
		# first delete all items currently in scene
		for item in default_items:
			item.queue_free()
		
		# get and load items from GameState dictionary
		for item in items_in_scene:
			items_parent.add_child(item)

func get_items_in_current_scene():
	var current_scene_path = get_tree().current_scene.scene_file_path
	var a = GameState.scene_to_items
	return GameState.scene_to_items.get(current_scene_path)

func set_items_in_current_scene(items: Array[Item]):
	var current_scene_path = get_tree().current_scene.scene_file_path
	GameState.scene_to_items[current_scene_path] = items

func add_item_to_current_scene(item: Item):
	var current_scene_path = get_tree().current_scene.scene_file_path
	GameState.remove_item_from_primary_inventory(item)
	GameState.primary_collected_item_ids.erase(item.id)
	GameState.add_item_to_scene(item, current_scene_path)
	items_parent.add_child(item)

func get_item_at_position(position):
	var items_in_scene = get_items_in_current_scene()
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
	GameState.add_item_to_primary_inventory(item)
	GameState.remove_item_from_scenes(item)
	item.get_parent().remove_child(item)
	inventory_updated.emit()
	
func drop_item(item: Item, position: Vector2):
	# TODO: selection with green and red selector
	print("Dropping item: %s" % item.item_name)
	add_item_to_current_scene(item)
	item.global_position = position
	inventory_updated.emit()
	
func save_items():
	var items_in_scene = get_items_in_current_scene()
	for item in items_in_scene:
		# prevents queue_free when scene is unloaded
		item.get_parent().remove_child(item)
