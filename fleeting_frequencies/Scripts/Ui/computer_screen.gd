extends Control
class_name ComputerScreen

@export var file_one_container: Control
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	if !visible:
		close_computer_screen()

func open_file_one(event: InputEvent):
	if event.is_action_pressed("primary_click"):
		print("opening file one")
		file_one_container.visible = true
		if !GameState.has_viewed_information:
			GameState.has_viewed_information = true
			audio_stream_player.play()
			await get_tree().create_timer(1.5).timeout
			WalkieTalkie.play()
			Dialogic.start_timeline("m_found_file")

func close_file_one(event: InputEvent):
	if event.is_action_pressed("primary_click"):
		print("closing file one")
		audio_stream_player.play()
		file_one_container.visible = false

func open_computer_screen():
	visible = true
	mouse_filter = MOUSE_FILTER_STOP

func close_computer_screen():
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE
