extends CharacterBody2D

signal hp_max_changed
signal hp_changed
signal died

# Exported variables with type hints and default values
@export var hp_max: int = 100:
	set(value): 
		if value != hp_max:
			hp_max = max(0, value)
			emit_signal("hp_max_changed", hp_max)
			self.hp = hp
@export var defense: int = 0
@export var speed: int = 60

var hp: int = hp_max:
	get: return hp
	set(value):
		if value != hp:
			hp = clamp(value, 0, hp_max)
			emit_signal("hp_changed")
			if hp == 0:
				emit_signal("died")

func receive_damage(base_damage: int):
	var actual_damage = base_damage
	actual_damage -= defense
	
	self.hp -= actual_damage
	print(name + " received " + str(actual_damage) + " damage")

func _on_hurt_box_area_entered(hitbox):
	receive_damage(hitbox.damage)
