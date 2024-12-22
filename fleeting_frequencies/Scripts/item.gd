extends Interaction
class_name Item

@onready var _area: Area2D = $Area2D
@onready var _sprite: Sprite2D = $ItemSprite
@onready var _collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

@export var id: String
@export var item_name: String
@export var description: String
@export var is_collectible: bool = false
@export var is_droppable: bool = false

func get_texture():
	return _sprite.texture

func is_position_on_item(position):
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	
	var out = space_state.intersect_point(params)
	for found_collider in out:
		if found_collider.get("collider") == _area:
			return true
	
	return false
