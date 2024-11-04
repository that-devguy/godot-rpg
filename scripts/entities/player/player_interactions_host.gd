class_name PlayerInteractionsHost extends Node2D


func _ready() -> void:
	pass 


func UpdateHitBoxDirection() -> void:
	var mouse_position = get_global_mouse_position()
	var direction_to_mouse = (mouse_position - global_position).normalized()
	
	if abs(direction_to_mouse.x) > abs(direction_to_mouse.y):
		if direction_to_mouse.x > 0:
			rotation_degrees = 90
		else:
			rotation_degrees = -90
	else:
		if direction_to_mouse.y > 0:
			rotation_degrees = -180
		else:
			rotation_degrees = 0
