extends Interaction

@onready var rays: Sprite2D = $Rays
@onready var dust_particles: GPUParticles2D = $DustParticles
@export var open_blinds_sprite: Texture2D
@export var closed_blinds_sprite: Texture2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
var is_open: bool = true

func _ready():
	super._ready()
	# load interaction state
	var game_manager = GameManager.get_parent_game_manager(self)
	var state = GameState.get_interaction_state_from_save(game_manager.scene_path, name)
	if state != null:
		load_interaction_state(state)
	update_state()

func handle_interaction(game_manager: GameManager = null):
	is_open = !is_open
	audio_stream_player.play()
	update_state()

func update_state():
	rays.visible = is_open
	dust_particles.visible = is_open
	if is_open:
		_interaction_sprite.texture = open_blinds_sprite
	else:
		_interaction_sprite.texture = closed_blinds_sprite

# Save keys
const save_key_is_open: String = "is_open"
func load_interaction_state(save_dictionary: Dictionary):
	if save_dictionary.get(save_key_is_open) != null:
		is_open = save_dictionary[save_key_is_open]
	update_state()

func get_interaction_state():
	# return dictionary with unique identifier of this element, variable and variable value
	var save_dictionary: Dictionary = {}
	save_dictionary[save_key_is_open] = is_open
	
	return save_dictionary
