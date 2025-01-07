extends Node
class_name InteractionManager

var interactions: Array[Interaction] = []

func _ready():
	_on_interactions_updated()

func get_interaction_at_position(position):
	for interaction in interactions:
		if interaction.is_position_on_interaction(position):
			print("Clicked on interaction %s" % interaction.name)
			return interaction

func _on_interactions_updated():
	var interaction_nodes = get_tree().get_nodes_in_group("interactions")
	interactions.assign(interaction_nodes)

func handle_interaction(interaction: Interaction, game_manager: GameManager = null):
	interaction.handle_interaction(game_manager)
