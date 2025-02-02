extends Control
class_name InputBlocker

var timer: float = 0

func _process(delta):
	timer -= delta
	if timer <= 0:
		timer = 0
		visible = false

func enable(duration_seconds: float):
	timer = duration_seconds
	visible = true
