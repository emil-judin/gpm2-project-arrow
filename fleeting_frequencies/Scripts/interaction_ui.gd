extends Control
class_name InteractionUi

signal triggered_character_switch
@onready var scene_transition: SceneTransition = $SceneTransition
	
func on_character_switch_pressed():
	if GameState.is_male_player_active():
		scene_transition.transition_to_past()
	else:
		scene_transition.transition_to_future()
	# wait for animation to finish
	# animation time currently hardcoded
	await get_tree().create_timer(1.5).timeout
	triggered_character_switch.emit()
