extends TextureRect

var mouse_in = false
var dragging = false

func _process(delta):
	if (mouse_in && Input.is_action_pressed("primary_click")):
		dragging = true
	if (dragging && Input.is_action_pressed("primary_click")):
		position = get_global_mouse_position()
		print("dragging")
	elif dragging:
		position = Vector2.ZERO
	else:
		dragging = false

func mouse_entered_texture():
	print("entered")
	mouse_in = true
	
func mouse_exited_texture():
	mouse_in = false
