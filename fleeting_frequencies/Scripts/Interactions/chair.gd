extends Interaction
class_name Chair

@export var sit_position: Node2D

func handle_interaction(game_manager: GameManager = null):
	game_manager.player.sit_down(self)
