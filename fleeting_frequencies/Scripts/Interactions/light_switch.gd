extends Interaction

@export var toggle_light: ToggleLight
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func handle_interaction(game_manager: GameManager = null):
	toggle_light.handle_interaction()
	audio_stream_player.play()
