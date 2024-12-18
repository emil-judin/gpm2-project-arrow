extends Control
class_name InteractionUi

signal triggered_character_switch

func on_character_switch_pressed():
	triggered_character_switch.emit()
