extends CharacterBody2D

# Exported variables with type hints and default values
@export var hp_max: int = 100
@export var hp: int = hp_max
@export var defense: int = 0

func  receive_damage(base_damage: int):
	var actual_damage = base_damage
	actual_damage -= defense
	
	self.hp -= actual_damage
	print(name + " received " + str(actual_damage) + " damage")
	

func _on_hurt_box_area_entered(hitbox):
	receive_damage(hitbox.damage)
