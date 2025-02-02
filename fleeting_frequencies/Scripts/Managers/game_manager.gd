extends Node2D
class_name GameManager

enum ItemAction{
	PICK_UP,
	DROP,
	USE
}

const female_diner_scene_path = "res://Scenes/Maps/F_Diner.tscn"
const male_diner_scene_path = "res://Scenes/Maps/M_Diner.tscn"
const male_bedroom_scene_path = "res://Scenes/Maps/M_Bedroom.tscn"
const female_bedroom_scene_path = "res://Scenes/Maps/F_Bedroom.tscn"

@export_file("*.tscn") var scene_path: String
@export var player: Player
@export var map: Map
@export var camera: Camera
@export_category("Managers")
@export var item_manager: ItemManager
@export var interaction_manager: InteractionManager
@export var sound_manager: SoundManager
@export var puzzle_managers: Array[Node]
@export_category("UI")
@export var inventory_ui: InventoryUi
@export var interaction_ui: InteractionUi
@export var input_blocker: InputBlocker
@export var scene_transition: SceneTransition
@export var dual_viewport: DualViewport
var current_interaction_target: Interaction = null
var current_item_action: ItemAction = ItemAction.PICK_UP
var drop_position: Vector2
var using_item: Item

func _ready():
	if GameState.debug:
		player.movement_speed *= 2
	
	player.target_reached.connect(_on_target_reached)
	item_manager.inventory_updated.connect(_on_inventory_updated)
	inventory_ui.dropped_item.connect(initiate_drop_item)
	inventory_ui.used_item.connect(initiate_use_item)
	interaction_ui.triggered_character_switch.connect(switch_character)
	
	set_player_position(GameState.current_scene_transition_type)
	player.init_player(map)
	camera.init_camera(map, player)
	scene_transition.play_new_scene_transition(GameState.current_scene_transition_type)

func _unhandled_input(event):
	if event.is_action_pressed("primary_click"):
		event = event as InputEventMouse
		var event_position = get_global_mouse_position()
		player.set_navigation_target(event_position)
		
		var item = item_manager.get_item_at_position(event_position)
		var interaction = interaction_manager.get_interaction_at_position(event_position)
		if item != null:
			current_interaction_target = item
		elif interaction != null:
			current_interaction_target = interaction
		else:
			# Default: move
			current_interaction_target = null

func get_scene_name():
	return scene_path.get_file().get_basename()

func set_player_position(scene_transition_type: GameState.SCENE_TRANSITION_TYPE):
	match scene_transition_type:
		GameState.SCENE_TRANSITION_TYPE.MELT, GameState.SCENE_TRANSITION_TYPE.DUAL:
			player.load_player_state_from_save()
		GameState.SCENE_TRANSITION_TYPE.PIXEL:
			# for switching rooms:
			# currently only works for 1:1 doors
			var doors: Array[Door] = []
			doors.assign(get_tree().get_nodes_in_group("doors"))
			var correct_doors = doors.filter(func(d): return d.destination_scene_path == GameState.last_scene_path)
			if correct_doors.size() > 0:
				player.global_position = correct_doors[0].global_position
		GameState.SCENE_TRANSITION_TYPE.NONE:
			# use spawn point defined in scene
			pass

func _on_target_reached():
	if current_interaction_target is Item:
		var item = current_interaction_target as Item
		if current_item_action == ItemAction.PICK_UP:
			item_manager.handle_pick_up(item)
		elif current_item_action == ItemAction.DROP:
			item_manager.handle_drop(item, drop_position)
			current_item_action = ItemAction.PICK_UP
	elif current_interaction_target is Interaction:
		if current_item_action == ItemAction.USE:
			item_manager.handle_use(using_item, current_interaction_target, self)
			current_item_action = ItemAction.PICK_UP
		else:
			interaction_manager.handle_interaction(current_interaction_target, self)

func initiate_drop_item(item: Item, drop_position: Vector2):
	current_item_action = ItemAction.DROP
	current_interaction_target = item
	self.drop_position = drop_position
	player.set_navigation_target(drop_position)

func initiate_use_item(item: Item, interaction_target: Interaction):
	current_item_action = ItemAction.USE
	current_interaction_target = interaction_target
	using_item = item
	player.set_navigation_target(interaction_target.global_position)

func _on_inventory_updated():
	inventory_ui.update_inventory_ui()

func switch_character():
	save_scene()
	GameState.switch_character(get_tree().current_scene.scene_file_path)
	GameState.current_scene_transition_type = GameState.SCENE_TRANSITION_TYPE.MELT
	get_tree().change_scene_to_file(GameState.current_scene_path)

func switch_room(destination_scene_path: String):
	scene_transition.transition_to_room()
	# hardcoded animation length
	await get_tree().create_timer(1.5).timeout
	save_scene()
	GameState.switch_room(destination_scene_path)
	GameState.current_scene_transition_type = GameState.SCENE_TRANSITION_TYPE.PIXEL
	get_tree().change_scene_to_file(GameState.current_scene_path)

func save_scene():
	item_manager.save_items()
	save_scene_state()

func save_scene_state():
	var scene_interaction_state = SceneInteractionState.new()
	scene_interaction_state.scene_path = GameState.current_scene_path
	
	# save player
	scene_interaction_state.player_position = player.global_position
	scene_interaction_state.player_is_sitting = player.is_sitting
	scene_interaction_state.player_standup_position = player.stand_up_position
	
	# save interaction states
	for i in interaction_manager.interactions:
		if i.has_method("get_interaction_state"):
			var interactions_state = i.get_interaction_state()
			var node_dictionary: Dictionary = {}
			scene_interaction_state.interaction_states[i.name] = interactions_state
	
	var dir = DirAccess.open("user://")
	if !dir.dir_exists("saves"):
		dir.make_dir("saves")
	ResourceSaver.save(scene_interaction_state, "user://saves/%s.tres" % GameState.get_current_scene_name())

func repair_walkie_talkie(required_item_ids: Array[String]):
	GameState.repaired_walkie_talkie = true
	item_manager.delete_item_by_ids(required_item_ids)
	update_puzzles()
	
func distract_sister(required_item_ids: Array[String]):
	GameState.distracted_sister = true
	item_manager.delete_item_by_ids(required_item_ids)
	update_puzzles()

func play_diner_cutscene():
	if !GameState.has_passed_diner_cutscene:
		if GameState.is_male_player_active():
			GameState.diner_male_cutscene_ready = true
		else:
			GameState.diner_female_cutscene_ready = true
		
		# lock standing up for player
		GameState.set_current_player_locked(true)
		
		if GameState.diner_male_cutscene_ready and GameState.diner_female_cutscene_ready:
			GameState.current_scene_transition_type = GameState.SCENE_TRANSITION_TYPE.DUAL
			set_cutscene_mode(true)
			if GameState.is_male_player_active():
				var new_game_manager = load(female_diner_scene_path).instantiate() as GameManager
				new_game_manager.set_cutscene_mode(true)
				dual_viewport.add_scene(new_game_manager)
				new_game_manager.position.x += 160
				dual_viewport.visible = true
				dual_viewport.slide_in_left()
			else:
				var new_game_manager = load(male_diner_scene_path).instantiate() as GameManager
				new_game_manager.set_cutscene_mode(true)
				dual_viewport.add_scene(new_game_manager)
				new_game_manager.position.x -= 160
				dual_viewport.visible = true
				dual_viewport.slide_in_right()
				
			await get_tree().create_timer(5).timeout
			Dialogic.start_timeline("mf_diner_cutscene")

func end_diner_cutscene():
	await get_tree().create_timer(3).timeout
	if GameState.is_male_player_active():
		dual_viewport.slide_out_left()
	else:
		dual_viewport.slide_out_right()
	
	GameState.is_male_player_locked = false
	GameState.is_female_player_locked = false
	GameState.has_passed_diner_cutscene = true
	var second_game_manager = dual_viewport.get_game_manager()
	#second_game_manager.set_cutscene_mode(false)
	GameState.current_scene_transition_type = GameState.SCENE_TRANSITION_TYPE.NONE
	
	await get_tree().create_timer(1.5).timeout
	# automatic room switch
	if GameState.is_male_player_active():
		switch_room(male_bedroom_scene_path)
		GameState.switch_room_inactive(female_bedroom_scene_path)
	else:
		switch_room(female_bedroom_scene_path)
		GameState.switch_room_inactive(male_bedroom_scene_path)

	#set_cutscene_mode(false)
	# TODO: unload scene from viewport

func update_puzzles():
	for p in puzzle_managers:
		p.update_puzzle_state()

func set_cutscene_mode(is_enabled: bool):
	interaction_ui.visible = !is_enabled
	inventory_ui.visible = !is_enabled
	input_blocker.visible = is_enabled

static func get_parent_game_manager(node: Node):
	var parent = node.get_parent()
	if parent == null:
		return null
	elif parent is GameManager:
		return parent as GameManager
	else:
		return get_parent_game_manager(parent)

#func load_scene_into_viewport(scene_path: String):
	## Test code for async scene loading, is problematic because of groups for interaction
	#var root = get_tree().get_root()
	#var old_scene = get_tree().current_scene
	#
	#var new_scene = load(scene_path).instantiate()
	#root.add_child(new_scene)
	#get_tree().set_current_scene(new_scene)
	#root.remove_child(old_scene)
	#
	#old_scene.free()
