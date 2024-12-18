extends Node2D

@export_file("*.tscn") var scene_path

func switch_to_target_scene():
	get_tree().change_scene_to_file(scene_path)
	
func _on_door_entered(area: Area2D):
	print("door entered")
	if area.get_parent() is Player:
		# TODO: do some saving?
		switch_to_target_scene()
