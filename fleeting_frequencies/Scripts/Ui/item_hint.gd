extends PanelContainer
class_name ItemHint

@export var item_name_label: RichTextLabel
@export var item_description_label: RichTextLabel
const offset: int = 1

func _ready():
	hide()

func show_item_hint(icon_panel: Control, item_name: String, item_description: String):
	item_name_label.text = item_name
	item_description_label.text = item_description
	
	# Godot bug, remove this when fixed: https://github.com/godotengine/godot/issues/20623
	await get_tree().process_frame
	await get_tree().process_frame
	
	# set position
	var new_position = icon_panel.global_position
	new_position.x += icon_panel.size.x / 2
	new_position.x -= self.size.x / 2 * scale.x
	new_position.y -= self.size.y * scale.y
	new_position.y -= offset
	global_position = new_position
	
	visible = true

func hide_item_hint():
	item_name_label.text = ""
	item_description_label.text = ""
	visible = false
