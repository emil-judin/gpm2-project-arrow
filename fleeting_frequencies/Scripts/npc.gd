extends Interaction
class_name Npc

@onready var _area: Area2D = $Area2D
@onready var _collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

@export var id: String
@export var npc_name: String
@export var texture: Texture2D
@export var description: String
@export var is_interactable: bool

func _ready():
	add_to_group("interactions")

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

func handle_interaction():
	if is_interactable:
		Dialogic.start('test_timeline')
