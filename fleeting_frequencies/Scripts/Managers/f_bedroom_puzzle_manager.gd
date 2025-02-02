extends PuzzleManager

func _ready():
	update_puzzle_state()

func update_puzzle_state():
	if GameState.has_passed_diner_cutscene && !GameState.has_returned_from_diner:
		GameState.has_returned_from_diner = true
		var game_manager = GameManager.get_parent_game_manager(self)
		game_manager.set_cutscene_mode(true)
		
		await get_tree().create_timer(2).timeout
		WalkieTalkie.play()
		Dialogic.start_timeline("mf_return_from_diner")
