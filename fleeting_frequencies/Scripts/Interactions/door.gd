extends Interaction
class_name Door

@export_file("*.tscn") var destination_scene_path: String
@export var locked: bool = false
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func handle_interaction(game_manager: GameManager = null):
	if !locked:
		game_manager.switch_room(destination_scene_path)
		if name.contains("Door"):
			await get_tree().create_timer(0.25).timeout
			audio_stream_player.play()
