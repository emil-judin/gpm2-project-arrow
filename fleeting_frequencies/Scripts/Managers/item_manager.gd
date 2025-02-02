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
	var current_scene_path = GameState.current_scene_path
	return GameState.scene_to_items.get(current_scene_path)

func set_items_in_current_scene(items: Array[Item]):
	var current_scene_path = GameState.current_scene_path
	GameState.scene_to_items[current_scene_path] = items

func get_item_at_position(position):
	var items_in_scene = get_items_in_current_scene()
	for item in items_in_scene:
		if item.is_position_on_interaction(position):
			print("Clicked on item %s" % item.id)
			return item

func handle_pick_up(item: Item):
	item.handle_interaction(null)
	if item.is_collectible:
		collect_item(item)

func handle_drop(item: Item, position: Vector2):
	if item.is_droppable:
		drop_item(item, position)

func handle_use(item: Item, interaction_target: Interaction, game_manager: GameManager):
	item.use_on(interaction_target, game_manager)

func collect_item(item: Item):
	print("Adding item: %s" % item.item_name)
	var current_scene_path = GameState.current_scene_path
	GameState.collect_item(item, current_scene_path)
	item.get_parent().remove_child(item)
	inventory_updated.emit()
	
	if !GameState.collected_first_hidden_item && GameState.hidden_first_item && item.id == "computer_mouse" && GameState.is_male_player_active():
		GameState.collected_first_hidden_item = true
		WalkieTalkie.play()
		Dialogic.start_timeline("m_collected_first_hidden_item")
		print("collected first hidden item")

func drop_item(item: Item, position: Vector2):
	print("Dropping item: %s" % item.item_name)
	var current_scene_path = GameState.current_scene_path
	GameState.drop_item(item, current_scene_path)
	items_parent.add_child(item)
	item.disable_highlight()
	item.global_position = position
	inventory_updated.emit()

func delete_item_by_ids(item_ids: Array[String]):
	print("Deleting items: %s" % str(item_ids))
	GameState.delete_items_by_id(item_ids)
	inventory_updated.emit()

func save_items():
	var items_in_scene = get_items_in_current_scene()
	for item in items_in_scene:
		# prevents queue_free when scene is unloaded
		item.get_parent().remove_child(item)
