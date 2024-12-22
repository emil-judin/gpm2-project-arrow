extends Node

enum CharacterType{
	MALE,
	FEMALE
}

var current_character: CharacterType = CharacterType.MALE
var last_scene_path
var last_male_scene_path: String = "res://Scenes/MaleTestRoom.tscn"
var last_female_scene_path: String = "res://Scenes/FemaleTestRoom.tscn"
var primary_inventory: Array[Item] = []
var secondary_inventory: Array[Item] = []
var primary_collected_item_ids: Dictionary = {}
var secondary_collected_item_ids: Dictionary = {}
# TODO: should i remove this and only work with scene_to_items?
# key: String, value: Array[Item]
var hide_spot_id_to_items: Dictionary = {}
# key: scene path, value: Array[Item]
var scene_to_items: Dictionary = {}

func switch_character(current_scene_path):
	last_scene_path = current_scene_path
	
	# switch inventories
	var temp_primary_inventory = primary_inventory
	primary_inventory = secondary_inventory
	secondary_inventory = temp_primary_inventory
	
	# switch collected items
	var temp_primary_collected_items = primary_collected_item_ids
	primary_collected_item_ids = secondary_collected_item_ids
	secondary_collected_item_ids = temp_primary_collected_items
	
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

func add_item_to_primary_inventory(item: Item):
	if primary_collected_item_ids.has(item.id):
		print("Error: item with id %s is already in inventory" % item.id)
		return
		
	primary_collected_item_ids[item.id] = true
	primary_inventory.append(item)
	print("Added item %s to inventory" % item.id)

func remove_item_from_primary_inventory(item: Item):
	primary_inventory.erase(item)
	print("Removed item %s from inventory" % item.id)

func has_collected_in_primary_inventory(item: Item):
	return primary_collected_item_ids.has(item.id) && primary_collected_item_ids[item.id] == true

# TODO: fix or remove
#func add_item_to_hide_spot(item: Item, hide_spot_id: String):
	#var items = hide_spot_id_to_items[hide_spot_id] as Array[Item]
	#var new_items
	#if items == null or items.size() == 0:
		#new_items = [item]
	#else:
		#items.append(item)
	#
	#hide_spot_id_to_items[hide_spot_id] = new_items

func add_item_to_scene(item: Item, scene_path: String):
	var items = scene_to_items.get(scene_path)
	if items == null:
		scene_to_items[scene_path] = [item]
	else:
		if !items.has(item):
			items.append(item)
	var a = scene_to_items
	var b = "abc"

func remove_item_from_scenes(item: Item):
	for i in scene_to_items.values():
		if i != null:
			var item_array = i as Array[Item]
			item_array.erase(item)
