class_name State_Attack3 extends State


@export_range(1,20,0.5) var decelerate_speed : float = 5.0
@export var lunge_speed : float = 100

@onready var attack_hurt_box: HurtBox = %AttackHurtBox
@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"
@onready var weapon: Sprite2D = $"../../Player/Weapon"
@onready var weapon_anims: AnimationPlayer = $"../../Player/Weapon/WeaponAnims"

var attacking : bool = false


# What happens when the player enters this State
func Enter() -> void:
	player.UpdateAnim("sword_attack3")
	player.anim.animation_finished.connect(EndAttack)
	
	weapon_anims.play("combo_attack3")
	
	update_weapon_rotation()

	
	attack_hurt_box.source_state = self
	attacking = true
	
	# Calculate the direction toward the mouse position and set a lunge velocity
	var direction_to_mouse = (
		player.get_global_mouse_position() - player.global_position
		).normalized()
	player.velocity = direction_to_mouse * lunge_speed
	
	
	await get_tree().create_timer(0.2).timeout #Delays hit for peak swing
	attack_hurt_box.monitoring = true
	
	pass


# What happens when the player exits this State
func Exit() -> void:
	player.anim.animation_finished.disconnect(EndAttack)
	attacking = false
	attack_hurt_box.monitoring = false
	
	weapon.offset.y = 0 # Reset offset
	
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


# Update the weapon rotation based on mouse position
func update_weapon_rotation() -> void:
	var direction_to_mouse = (player.get_global_mouse_position() - player.global_position).normalized()
	weapon.rotation = direction_to_mouse.angle() + deg_to_rad(270)
	
	# Reset offset weapon only when the mouse is in the "down" direction
	if player.AnimDirection() == "up":
		weapon.offset.y = -6
	else:
		weapon.offset.y = 0
