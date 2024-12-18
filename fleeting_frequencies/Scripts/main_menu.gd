extends Control

var start_scene: String = "res://Scenes/MaleTestRoom.tscn"

func start_game():
	get_tree().change_scene_to_file(start_scene)

func quit_game():
	get_tree().quit()
