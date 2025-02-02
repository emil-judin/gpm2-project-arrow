extends Node

var dialogic_male_character = "res://Dialogic/Characters/male_character.dch"
var dialogic_female_character = "res://Dialogic/Characters/female_character.dch"

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
func _on_dialogic_signal(argument: String):
	match argument:
		"on_walkie_talkie_repaired": on_walkie_talkie_repaired()
		"on_first_contact_made": on_first_contact_made()
		"on_diner_cutscene_finished": on_diner_cutscene_finished()
		"on_returned_from_diner_cutscene": on_returned_from_diner_cutscene()
		"on_tv_message": on_tv_message()

func start_text_dialog(text: String):
	var text_event = DialogicTextEvent.new()
	text_event.text = text
	if GameState.is_male_player_active():
		text_event.character = load(dialogic_male_character)
	else:
		text_event.character = load(dialogic_female_character)
	
	var events : Array = []
	events.append(text_event)

	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = events
	# if your events are already resources, you need to add this:
	timeline.events_processed = true
	Dialogic.start(timeline)

func start_invalid_interaction_dialog(custom_invalid_interaction_text = null):
	const invalid_text = "Nope"
	
	if custom_invalid_interaction_text != null:
		start_text_dialog(custom_invalid_interaction_text)
	else:
		start_text_dialog(invalid_text)

func on_walkie_talkie_repaired():
	var current_game_manager = get_tree().current_scene as GameManager
	var wait_duration = 1.5
	
	current_game_manager.input_blocker.enable(wait_duration)
	await get_tree().create_timer(wait_duration).timeout
	
	WalkieTalkie.play()
	Dialogic.start_timeline("mf_first_contact")

func on_returned_from_diner_cutscene():
	var current_game_manager = get_tree().current_scene as GameManager
	current_game_manager.set_cutscene_mode(false)
	
func on_diner_cutscene_finished():
	var current_game_manager = get_tree().current_scene as GameManager
	current_game_manager.end_diner_cutscene()

func on_first_contact_made():
	var current_game_manager = get_tree().current_scene as GameManager
	current_game_manager.interaction_ui.enable_character_switch()
	current_game_manager.inventory_ui.enable_secondary_inventory()

func on_tv_message():
	# TODO: lights flicker
	# TODO: fade to black
	pass
