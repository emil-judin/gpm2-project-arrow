extends Interaction
class_name Computer

@export var computer_screen: ComputerScreen
@export var computer_with_mouse_sprite: Texture2D
@export var computer_without_mouse_sprite: Texture2D
const mouse_id = "computer_mouse"
var has_mouse: bool = false

func _ready():
	super._ready()
	# load interaction state
	var game_manager = GameManager.get_parent_game_manager(self)
	var state = GameState.get_interaction_state_from_save(game_manager.scene_path, name)
	if state != null:
		load_interaction_state(state)
	update_state()

func update_state():
	if has_mouse:
		_interaction_sprite.texture = computer_with_mouse_sprite
	else:
		_interaction_sprite.texture = computer_without_mouse_sprite

func handle_interaction(game_manager: GameManager = null):
	if has_mouse:
		computer_screen.open_computer_screen()

func interacted_by(item, game_manager: GameManager):
	if item.id == mouse_id:
		has_mouse = true
		game_manager.item_manager.delete_item_by_ids([mouse_id])
		update_state()
	else:
		super.interacted_by(item, game_manager)

# Save keys
const save_key_has_mouse: String = "has_mouse"
func load_interaction_state(save_dictionary: Dictionary):
	if save_dictionary.get(save_key_has_mouse) != null:
		has_mouse = save_dictionary[save_key_has_mouse]
	update_state()

func get_interaction_state():
	# return dictionary with unique identifier of this element, variable and variable value
	var save_dictionary: Dictionary = {}
	save_dictionary[save_key_has_mouse] = has_mouse
	
	return save_dictionary
