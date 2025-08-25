extends Node

@export var door_down: Door

func _process(delta):
	door_down.locked = !GameState.repaired_walkie_talkie
