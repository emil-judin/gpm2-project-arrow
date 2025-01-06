extends Node

@export var player: Player
@export var item_manager: ItemManager
@export var interaction_manager: InteractionManager
@export var sound_manager: SoundManager
@export var inventory_ui: InventoryUi
@export var interaction_ui: InteractionUi
@export var computer_screen: Control
var current_interaction_target: Interaction = null
var dropping_item = false
var drop_position: Vector2

func _ready():
	player.target_reached.connect(_on_target_reached)
	item_manager.inventory_updated.connect(_on_inventory_updated)

func _unhandled_input(event):
	if event.is_action_pressed("primary_click") && (computer_screen == null || !computer_screen.visible):
		event = event as InputEventMouse
		player.set_navigation_target(event.global_position)
		
		var item = item_manager.get_item_at_position(event.global_position)
		var interaction = interaction_manager.get_interaction_at_position(event.global_position)
		if item != null:
			current_interaction_target = item
		elif interaction != null:
			current_interaction_target = interaction
		else:
			# Default: move
			current_interaction_target = null

func _on_target_reached():
	if current_interaction_target is Item:
		var item = current_interaction_target as Item
		if !dropping_item:
			item_manager.handle_pick_up(item)
		else:
			item_manager.handle_drop(item, drop_position)
			dropping_item = false
	elif current_interaction_target is Interaction:
		var npc = current_interaction_target as Interaction
		interaction_manager.handle_interaction(npc)

func initiate_drop_item(item: Item, drop_position: Vector2):
	current_interaction_target = item
	dropping_item = true
	self.drop_position = drop_position
	player.set_navigation_target(drop_position)

func _on_inventory_updated():
	inventory_ui.update_inventory_ui()

func switch_character():
	item_manager.save_items()
	GameState.switch_character(get_tree().current_scene.scene_file_path)
	load_scene_with_melting_transition(GameState.current_scene_path)
	
func load_scene_with_melting_transition(scene_path: String):
	GameState.is_melting_transition = true
	
	get_tree().change_scene_to_file(scene_path)
	
	# Test code for async scene loading, is problematic because of groups for interaction
	#var root = get_tree().get_root()
	#var old_scene = get_tree().current_scene
	#
	#var new_scene = load(scene_path).instantiate()
	#root.add_child(new_scene)
	#get_tree().set_current_scene(new_scene)
	#root.remove_child(old_scene)
	#
	#old_scene.free()
