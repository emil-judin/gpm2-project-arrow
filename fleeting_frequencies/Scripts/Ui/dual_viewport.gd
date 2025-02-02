extends Control
class_name DualViewport

@onready var animation_player: AnimationPlayer = $SubViewportContainer/AnimationPlayer
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

func on_animation_finished(anim_name: StringName):
	if anim_name == "slide_out_left" or anim_name == "slide_out_right":
		clear_children()

func add_scene(scene: Node2D):
	sub_viewport.add_child(scene)

func get_game_manager():
	return sub_viewport.get_child(0) as GameManager

func slide_in_left():
	animation_player.play("slide_in_left")

func slide_out_left():
	animation_player.play("slide_out_left")

func slide_in_right():
	animation_player.play("slide_in_right")

func slide_out_right():
	animation_player.play("slide_out_right")

func clear_children():
	for child in sub_viewport.get_children():
		sub_viewport.remove_child(child)
		child.queue_free()
