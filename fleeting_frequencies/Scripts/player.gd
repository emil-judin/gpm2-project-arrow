class_name Player
extends Node2D

signal target_reached

@onready var animated_sprite: AnimatedSprite2D = $Container/AnimatedSprite2D
@export var movement_speed: float = 4.0
@export var target_desired_distance: float = 1
var navigation_is_finished: bool = true
var movement_delta: float
var target_postion_x: float

func _physics_process(delta):
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
	else:
		animated_sprite.play('idle')

func set_navigation_target(target_position):
	navigation_is_finished = false
	target_postion_x = target_position.x

func _on_target_reached():
	target_reached.emit()
