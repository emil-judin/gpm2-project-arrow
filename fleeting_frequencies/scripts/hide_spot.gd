extends Node
class_name HideSpot

@export var id: String
@export_file("*.tscn") var connected_scene_paths: Array[String] = []

func _area_entered(area: Area2D):
	if area.get_parent().is_in_group("items"):
		var item = area.get_parent() as Item
		if !item.is_collectible:
			# if item is not collectible, don't transfer it to other scenes
			return
		
		for scene_path in connected_scene_paths:
			print("saving to " + scene_path)
			GameState.add_item_to_scene(item, scene_path)
