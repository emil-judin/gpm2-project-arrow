extends Control
class_name SceneTransition

@onready var background: TextureRect = $MeltingTransitionBackground
@onready var melting_transition: MeltingTransition = $MeltingTransitionBackground/MeltingTransition
@onready var pixelation: Pixelation = $Pixelation
@export var melting_background_texture: Texture2D

func _ready():
	match GameState.current_scene_transition_type:
		GameState.SCENE_TRANSITION_TYPE.MELT:
			GameState.current_scene_transition_type = GameState.SCENE_TRANSITION_TYPE.NONE
			if GameState.is_male_player_active():
				transition_from_past()
			else:
				transition_from_future()
		GameState.SCENE_TRANSITION_TYPE.PIXEL:
			GameState.current_scene_transition_type = GameState.SCENE_TRANSITION_TYPE.NONE
			transition_from_room()

func transition_to_room():
	pixelation.play_pixel_out_animation()
	await get_tree().create_timer(1.5).timeout

func transition_from_room():
	pixelation.play_pixel_in_animation()

func transition_from_future():
	await transition(false, false)

func transition_to_future():
	await transition(true, true)

func transition_from_past():
	await transition(true, false)

func transition_to_past():
	await transition(false, true)

func transition(melt_right: bool, reverse: bool):
	melting_transition.generate_offsets(melting_background_texture)
	background.visible = true
	melting_transition.transition(melt_right, reverse)
	# animation time currently hardcoded
	await get_tree().create_timer(1.5).timeout
	background.visible = false
