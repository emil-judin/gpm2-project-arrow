extends Chair

func handle_interaction(game_manager: GameManager = null):
	super.handle_interaction(game_manager)
	game_manager.play_diner_cutscene()
