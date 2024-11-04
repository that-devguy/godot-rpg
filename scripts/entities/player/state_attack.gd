class_name State_Attack extends State


var attacking : bool = false

@export_range(1,20,0.5) var decelerate_speed : float = 5.0

@onready var weapon_anims: AnimatedSprite2D = $"../../AnimatedSprite2D/WeaponAnims"

@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"


# What happens when the player enters this State
func Enter() -> void:
	player.UpdateAnim("1h_attack")
	weapon_anims.play("1h_sword_attack_" + player.AnimDirection())
	_on_animated_sprite_2d_animation_finished()
	attacking = true
	ToggleWeapon()
	pass


# What happens when the player exits this State
func Exit() -> void:
	pass


# What happens during the _process update in this State
func Process(_delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null 


# What happens during the _physics_process update in this State
func Physics(_delta : float) -> State:
	return null


# What happens with input events in this State
func HandleInput(_event: InputEvent) -> State:
	return null


# Resets attacking to false once the attacking animation has finished
func _on_animated_sprite_2d_animation_finished() -> void:
	attacking = false
	ToggleWeapon()


func ToggleWeapon() -> void:
	weapon_anims.visible = attacking
