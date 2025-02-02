extends Node

# Reference to the global AudioStreamPlayer
var audio_player: AudioStreamPlayer
var background_music: AudioStreamPlayer

func _ready():
	# Create and add an AudioStreamPlayer to the scene
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = load("res://Audio/walkietalkie.wav")
	
	background_music = AudioStreamPlayer.new()
	add_child(background_music)
	

	# Optionally configure the audio player
	audio_player.volume_db = -10  # Set default volume

func play():
	audio_player.play()

func play_background():
	background_music.stream = load("res://Audio/music.mp3")
	background_music.autoplay = true
	background_music.volume_db = -20  # Set default volume
	background_music.play()

func play_intense():
	background_music.stream = load("res://Audio/music_intense.mp3")
	background_music.volume_db = -10  # Set default volume
	background_music.play()
