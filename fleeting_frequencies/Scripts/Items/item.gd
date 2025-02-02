extends Interaction
class_name Item

@export var item_name: String
@export var description: String
@export var is_collectible: bool = false
@export var is_droppable: bool = false
@export var interaction_text: String

func _ready():
	# Remember to call super._ready()!
	super._ready()

func handle_interaction(game_manager: GameManager = null):
	if interaction_text != null && interaction_text != "":
		DialogLoader.start_text_dialog(interaction_text)

func set_mock():
	id = "mock_" + id
	is_collectible = false
	is_droppable = false

func get_texture():
	return _interaction_sprite.texture

func use_on(interaction_target, game_manager: GameManager):
	if interaction_target.has_method("interacted_by"):
		interaction_target.interacted_by(self, game_manager)
