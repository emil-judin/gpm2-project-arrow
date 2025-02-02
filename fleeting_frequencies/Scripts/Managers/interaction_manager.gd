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

#func load_all_interaction_states():
	#var scene_interaction_state: SceneInteractionState = ResourceLoader.load("user://%s.tres" % GameState.get_current_scene_name()) as SceneInteractionState
	#if scene_interaction_state != null:
		#for state in scene_interaction_state.interaction_states:
			#var node_name = state.keys()[0]
			#var interaction = interactions.filter(func(i): return i.name == node_name)
			#for i in interaction:
				#i.load_interaction_state(state[node_name])
