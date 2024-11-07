class_name State_Attack extends State


var attacking : bool = false

@export_range(1,20,0.5) var decelerate_speed : float = 5.0
@export var lunge_speed : float = 100

@onready var weapon: Sprite2D = $"../../Player/Weapons"
@onready var weapon_anim: AnimationPlayer = $"../../Player/Weapons/WeaponAnims"
@onready var attack_hurt_box: HurtBox = %AttackHurtBox

@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"


# What happens when the player enters this State
func Enter() -> void:
	player.UpdateAnim("1h_attack")
	weapon_anim.play("1h_sword_attack_" + player.AnimDirection())
	weapon_anim.animation_finished.connect(EndAttack)
	attacking = true
	ToggleWeapon()
	
	# Calculate the direction toward the mouse position and set a lunge velocity
	var direction_to_mouse = (
		player.get_global_mouse_position() - player.global_position
		).normalized()
	player.velocity = direction_to_mouse * lunge_speed
	
	
	await get_tree().create_timer(0.075).timeout #Delays hit for peak swing
	attack_hurt_box.monitoring = true
	pass


# What happens when the player exits this State
func Exit() -> void:
	weapon_anim.animation_finished.disconnect(EndAttack)
	attacking = false
	attack_hurt_box.monitoring = false
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
func EndAttack(_newAnimName : String) -> void:
	attacking = false
	ToggleWeapon()


func ToggleWeapon() -> void:
	weapon.visible = attacking
