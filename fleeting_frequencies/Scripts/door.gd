extends Interaction
class_name Door

@onready var _area: Area2D = $Area2D
@onready var shape: CollisionShape2D = $Area2D/CollisionShape2D
@export_file("*.tscn") var destination_scene_path: String

func handle_interaction(game_manager: GameManager = null):
	game_manager.switch_room(destination_scene_path)

func is_position_on_interaction(position):
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	
	var out = space_state.intersect_point(params)
	for found_collider in out:
		if found_collider.get("collider") == _area:
			return true
	
	return false
