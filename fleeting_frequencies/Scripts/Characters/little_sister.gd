extends Npc
class_name LittleSister

var distraction_item_ids: Array[String] = ["brick"]

func _ready():
	super._ready()
	custom_invalid_interaction_text = "Naaah"

func handle_interaction(game_manager: GameManager = null):
	Dialogic.start_timeline("f_sister_bring_toy")

func interacted_by(item, game_manager: GameManager):
	if distraction_item_ids.has(item.id):
		game_manager.distract_sister(distraction_item_ids)
		Dialogic.start_timeline("f_sister_solved_distraction")
	else:
		super.interacted_by(item, game_manager)
