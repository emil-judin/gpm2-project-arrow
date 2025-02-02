extends Camera2D
class_name Camera

@export var follow_margin: float = 50
var player: Player = null

func init_camera(map: Map, player: Player):
	self.player = player
	
	limit_left = map.get_limit_left()
	limit_right = map.get_limit_right()
	
	#position_smoothing_enabled = false
	global_position.x = player.global_position.x
	#await get_tree().process_frame
	#position_smoothing_enabled = true

func _process(delta):
	if not player:
		return
	
	var player_position = player.global_position
	var camera_position = global_position
	
	# Calculate the difference between the camera and player positions
	var distance = player_position - camera_position
	
	# If the player moves outside the follow margin, move the camera
	if abs(distance.x) > follow_margin:
		camera_position.x = lerp(camera_position.x, player_position.x, 0.1)
	
	global_position.x = round(camera_position.x)
