extends ColorRect
class_name Pixelation

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_pixel_out_animation():
	animation_player.play("pixel_out")

func play_pixel_in_animation():
	animation_player.play("pixel_in")
