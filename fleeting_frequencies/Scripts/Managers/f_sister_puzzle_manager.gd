extends PuzzleManager

@export var door_to_diner: Door

func _ready():
	update_puzzle_state()

func update_puzzle_state():
	door_to_diner.locked = !GameState.distracted_sister
