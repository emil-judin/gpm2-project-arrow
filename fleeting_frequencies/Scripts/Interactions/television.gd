extends Interaction
class_name Television

func handle_interaction(game_manager: GameManager = null):
	if GameState.has_viewed_information:
		Dialogic.start_timeline("f_tv_message")
		WalkieTalkie.play_intense()
