class_name Player
extends Node2D

signal target_reached

@onready var animated_sprite: AnimatedSprite2D = $Container/AnimatedSprite2D
@export var movement_speed: float = 4.0
@export var target_desired_distance: float = 1
@export var player_width_px: int = 16
var navigation_is_finished: bool = true
var movement_delta: float
var target_postion_x: float
var stand_up_position: Vector2
var is_sitting = false
var limit_left: float = -INF
var limit_right: float = INF

func init_player(map: Map):
	# set limits
	limit_left = map.get_limit_left() + player_width_px
	limit_right = map.get_limit_right() - player_width_px
	
	if is_sitting:
		animated_sprite.position.y += 7

func _process(delta):
	if !navigation_is_finished:
		if abs(target_postion_x - global_position.x) <= target_desired_distance:
			_on_target_reached()
			navigation_is_finished = true
			# target has been reached
			return
		
		movement_delta = movement_speed * delta
		var new_velocity = Vector2(movement_delta, 0) if (target_postion_x - global_position.x> 0) else Vector2(-movement_delta, 0)
		global_position = global_position.move_toward(global_position + new_velocity, movement_delta)
		if new_velocity.x > 0:
			animated_sprite.flip_h = false
		elif new_velocity.x < 0:
			animated_sprite.flip_h = true
		animated_sprite.play('walk')
	elif is_sitting:
		animated_sprite.play('sitting')
	else:
		animated_sprite.play('idle')

func sit_down(chair: Chair):
	if GameState.is_current_player_locked():
		return
	
	if !is_sitting:
		global_position = chair.sit_position.global_position
		is_sitting = true
		stand_up_position = chair.global_position
		# TODO: remove!!!
		animated_sprite.position.y += 7
	# TODO: change sprite and add different sit directions

func stand_up():
	if GameState.is_current_player_locked():
		return
	
	if is_sitting:
		global_position = stand_up_position
		is_sitting = false
		modulate = Color.WHITE
		animated_sprite.position.y -= 7

func set_navigation_target(target_position):
	if GameState.is_current_player_locked():
		return
	
	if is_sitting:
		stand_up()
	navigation_is_finished = false
	target_postion_x = clamp(target_position.x, limit_left, limit_right)

func _on_target_reached():
	target_reached.emit()

func load_player_state_from_save():
	# load player state
	var game_manager = GameManager.get_parent_game_manager(self)
	var scene_state = GameState.get_scene_interaction_state_from_save(game_manager.scene_path)
	if scene_state != null:
		global_position = scene_state.player_position
		is_sitting = scene_state.player_is_sitting
		stand_up_position = scene_state.player_standup_position
