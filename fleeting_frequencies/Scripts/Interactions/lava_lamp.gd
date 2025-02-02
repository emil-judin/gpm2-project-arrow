extends Interaction

@export var light: PointLight2D
@export var is_on: bool
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	super._ready()
	# load interaction state
	var game_manager = GameManager.get_parent_game_manager(self)
	var state = GameState.get_interaction_state_from_save(game_manager.scene_path, name)
	if state != null:
		load_interaction_state(state)
	update_state()

func handle_interaction(game_manager: GameManager = null):
	is_on = !is_on
	update_state()
	audio_stream_player.play()

func update_state():
	light.visible = is_on

# Save keys
const save_key_is_on: String = "is_on"
func load_interaction_state(save_dictionary: Dictionary):
	if save_dictionary.get(save_key_is_on) != null:
		is_on = save_dictionary[save_key_is_on]
	update_state()

func get_interaction_state():
	# return dictionary with unique identifier of this element, variable and variable value
	var save_dictionary: Dictionary = {}
	save_dictionary[save_key_is_on] = is_on
	
	return save_dictionary
