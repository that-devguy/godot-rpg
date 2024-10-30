extends "res://scripts/entities/entity_base.gd"

func _ready():
	# Sets the initial idle animation when the scene loads
	$AnimatedSprite2D.play("fly_down")
