extends Resource
class_name SceneInteractionState

@export var scene_path: String = ""
# player
@export var player_position: Vector2
@export var player_is_sitting: bool
@export var player_standup_position: Vector2
# interactions
# node_name to variable dictionary
@export var interaction_states: Dictionary = {}
