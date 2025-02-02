extends Sprite2D
class_name Map

func get_limit_left():
	return global_position.x

func get_limit_right():
	return global_position.x + texture.get_size().x
