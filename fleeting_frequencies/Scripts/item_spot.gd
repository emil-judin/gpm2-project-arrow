extends Node
class_name ItemSpot

func on_item_spot_entered(area: Area2D):
	if area.get_parent() is Drag:
		var drag = area.get_parent() as Drag
		drag.on_item_spot_entered()

func on_item_spot_exited(area: Area2D):
	if area.get_parent() is Drag:
		var drag = area.get_parent() as Drag
		drag.on_item_spot_exited()
