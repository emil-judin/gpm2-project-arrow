extends Node2D
class_name Interaction

@export var id: String
@onready var _interaction_sprite: Sprite2D = $InteractionSprite
@onready var _click_area: Area2D = $ClickArea
@onready var _click_shape: CollisionShape2D = $ClickArea/ClickShape
# used for special interactions and special dialogs
@export var item_id_to_dialog: Dictionary
var custom_invalid_interaction_text = null

func _ready():
	if _click_area != null and _click_shape != null:
		_click_area.area_entered.connect(_on_click_area_entered)
		_click_area.area_exited.connect(_on_click_area_exited)
	else:
		push_error("UNIMPLEMENTED ERROR: _click_area or _click_shape not set")

	if _interaction_sprite != null:
		_interaction_sprite.material.set_shader_parameter("flip_h", _interaction_sprite.flip_h)
		_click_area.mouse_entered.connect(_on_mouse_entered)
		_click_area.mouse_exited.connect(_on_mouse_exited)
	else:
		push_error("UNIMPLEMENTED ERROR: _interaction_sprite not set")

func interacted_by(item: Item, game_manager: GameManager):
	if item_id_to_dialog.has(item.id):
		var text = item_id_to_dialog.get(item.id)
		DialogLoader.start_text_dialog(text)
	else:
		DialogLoader.start_invalid_interaction_dialog(custom_invalid_interaction_text)

func trigger_special_interaction(game_manager: GameManager = null):
	push_error("UNIMPLEMENTED ERROR: handle_interaction is missing")

func is_position_on_interaction(position):
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = position
	params.collide_with_areas = true
	
	var out = space_state.intersect_point(params)
	for found_collider in out:
		if found_collider.get("collider") == _click_area:
			return true
	
	return false

func _on_mouse_entered():
	enable_highlight()
	
func _on_mouse_exited():
	disable_highlight()

func enable_highlight():
	_interaction_sprite.material.set_shader_parameter("flip_h", _interaction_sprite.flip_h)
	_interaction_sprite.material.set_shader_parameter("width", 1)

func disable_highlight():
	_interaction_sprite.material.set_shader_parameter("width", 0)

func _on_click_area_entered(area: Area2D):
	if area.get_parent() is Drag:
		var drag = area.get_parent() as Drag
		enable_highlight()
		drag.on_interaction_entered(self)

func _on_click_area_exited(area: Area2D):
	if area.get_parent() is Drag:
		var drag = area.get_parent() as Drag
		disable_highlight()
		drag.on_interaction_exited()
