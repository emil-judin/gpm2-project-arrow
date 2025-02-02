extends Interaction

var required_item_ids: Array[String] = ["battery", "screw_driver"]
var current_game_manager: GameManager = null

func _ready():
	super._ready()
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	if GameState.repaired_walkie_talkie:
		visible = false
		_click_shape.disabled = true

func handle_interaction(game_manager: GameManager = null):
	Dialogic.start_timeline("m_repair_walkie_talkie")
	current_game_manager = game_manager

func _on_dialogic_signal(argument: String):
	if argument == "check_repair":
		var can_repair = GameState.has_item_ids_in_primary_inventory(required_item_ids)
		if can_repair:
			current_game_manager.repair_walkie_talkie(required_item_ids)
			visible = false
			_click_shape.disabled = true
