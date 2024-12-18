extends Control

@export var file_one_container: Control

func _ready():
	if !visible:
		close_computer_screen()

func open_file_one(event: InputEvent):
	if event.is_action_pressed("primary_click"):
		print("opening file one")
		file_one_container.visible = true

func close_file_one(event: InputEvent):
	if event.is_action_pressed("primary_click"):
		print("closing file one")
		file_one_container.visible = false

func close_computer_screen():
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE
