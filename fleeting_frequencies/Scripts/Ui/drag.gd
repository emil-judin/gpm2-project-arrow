extends TextureRect
class_name Drag

signal dropped_item_icon(index: int, drop_position: Vector2)
signal used_item_icon(index: int, interaction_target: Interaction)
signal hovered_item_icon(index: int)
signal unhovered_item_icon()

@export var item_position: int
@export var drag_color_valid: Color = "00d500bc"
@export var drag_color_invalid: Color = "d60e00bc"
@export var drag_color_interaction: Color = "ffffff00"
@onready var _collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var _area: Area2D = $Area2D
var start_modulate: Color
var mouse_in = false
var dragging = false
var is_valid_drop_position = false
var interaction_target: Interaction = null
var initial_parent: Node

func _ready():
	initial_parent = get_parent()
	start_modulate = modulate
	interaction_target = null

func _process(delta):
	if (mouse_in && Input.is_action_pressed("primary_click")):
		if !dragging:
			# attach to game manager for global coordinates
			var game_manager = GameManager.get_parent_game_manager(self)
			initial_parent.remove_child(self)
			game_manager.add_child(self)
			
			dragging = true
			modulate = drag_color_invalid
	
	if dragging:
		if Input.is_action_pressed("primary_click") && texture != null:
			var new_position = get_global_mouse_position() - texture.get_size() / 2
			new_position.x = round(new_position.x)
			new_position.y = round(new_position.y)
			global_position = new_position
			_area.global_position = new_position
			unhovered_item_icon.emit()
		else:
			# get global position and reattach to game manager
			var global_drop_position = _collision_shape.global_position
			var game_manager = GameManager.get_parent_game_manager(self)
			game_manager.remove_child(self)
			initial_parent.add_child(self)
			
			dragging = false
			mouse_in = false
			modulate = start_modulate
			var center_container = get_parent_control() as Container
			center_container.queue_sort()
			
			# interaction targets have priority over dropping
			if interaction_target != null:
				used_item_icon.emit(item_position, interaction_target)
				interaction_target = null
			elif is_valid_drop_position:
				dropped_item_icon.emit(item_position, global_drop_position)
				is_valid_drop_position = false

func set_icon_texture(icon_texture: Texture2D):
	texture = icon_texture
	var rectangle_shape = _collision_shape.shape as RectangleShape2D
	if icon_texture != null:
		var shape_size = Vector2(1, 0)
		rectangle_shape.set_size(shape_size)
		_collision_shape.global_position = global_position + Vector2(texture.get_size().x / 2, texture.get_size().y)
	else:
		rectangle_shape.size = Vector2.ZERO

func on_item_spot_entered():
	if dragging:
		is_valid_drop_position = true
		modulate = drag_color_valid

func on_item_spot_exited():
	if dragging:
		is_valid_drop_position = false
		modulate = drag_color_invalid

func on_interaction_entered(interaction: Interaction):
	if dragging:
		interaction_target = interaction
		modulate = drag_color_interaction

func on_interaction_exited():
	if dragging:
		interaction_target = null
		modulate = drag_color_invalid

func mouse_entered_texture():
	mouse_in = true
	if !dragging:
		hovered_item_icon.emit(item_position)

func mouse_exited_texture():
	mouse_in = false
	unhovered_item_icon.emit()
