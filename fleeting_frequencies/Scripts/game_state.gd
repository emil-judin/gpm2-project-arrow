extends Node

enum CharacterType{
	MALE,
	FEMALE
}

const inventory_size = 5

var current_character: CharacterType = CharacterType.MALE
var last_scene_path
var last_male_scene_path: String = "res://Scenes/MaleTestRoom.tscn"
var last_female_scene_path: String = "res://Scenes/FemaleTestRoom.tscn"
var primary_inventory: Array[Item] = []
var secondary_inventory: Array[Item] = []
var collected_item_ids: Dictionary = {}
var mouse = false
var computer_active = false

func switch_character(current_scene_path):
	last_scene_path = current_scene_path
	
	# switch inventories
	var temp_primary_inventory = primary_inventory
	primary_inventory = secondary_inventory
	secondary_inventory = temp_primary_inventory
	
	if current_character == CharacterType.MALE:
		# switch to female scene
		last_male_scene_path = current_scene_path
		current_character = CharacterType.FEMALE
		get_tree().change_scene_to_file(last_female_scene_path)
	elif current_character == CharacterType.FEMALE:
		# switch to male scene
		last_female_scene_path = current_scene_path
		current_character = CharacterType.MALE
		get_tree().change_scene_to_file(last_male_scene_path)

func mouse_added():
	mouse = true

func add_item_to_inventory(item: Item):
	if collected_item_ids.has(item.id):
		print("Error: item with id %s is already in inventory" % item.id)
		return
		
	collected_item_ids[item.id] = true
	primary_inventory.append(item)
	print("Added item %s to inventory" % item.id)

func remove_item_from_inventory(item: Item):
	primary_inventory.erase(item)
	print("Removed item %s from inventory" % item.id)

func has_collected(item: Item):
	return collected_item_ids.has(item.id) && collected_item_ids[item.id] == true
