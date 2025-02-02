extends Control

var start_scene: String = "res://Scenes/Maps/M_Bedroom.tscn"
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func start_game(event: InputEvent):
	if event.is_action_pressed("primary_click"):
		audio_stream_player.play()
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file(start_scene)
		WalkieTalkie.play_background()

func quit_game(event: InputEvent):
	if event.is_action_pressed("primary_click"):
		audio_stream_player.play()
		await get_tree().create_timer(0.2).timeout
		get_tree().quit()
