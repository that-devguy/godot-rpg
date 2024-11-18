class_name State_Attack1 extends State


@export_range(1,20,0.5) var decelerate_speed : float = 5.0
@export var lunge_speed : float = 100
@export var combo_window_delay: float = 0.1 # Time before the combo can be initialized
@export var attack_2: State 

@onready var attack_hurt_box: HurtBox = %AttackHurtBox
@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"
@onready var player_sprite: Sprite2D = $"../../Player"
@onready var weapon_sprite: Sprite2D = $"../../Player/WeaponHolder/Weapon"
@onready var weapon_holder: Node2D = $"../../Player/WeaponHolder"
@onready var weapon_anims: AnimationPlayer = $"../../Player/WeaponHolder/Weapon/WeaponAnims"

var attacking : bool = false
var attack_queued: bool = false


# What happens when the player enters this State
func Enter() -> void:
	player.UpdateAnim("attack")
	weapon_sprite.z_index = 0
	
	weapon_anims.animation_finished.connect(EndAttack)
	weapon_anims.play("combo_attack1")
	weapon_anims.queue("RESET")
	
	update_weapon_rotation()
	
	attack_hurt_box.source_state = self
	attacking = true
	attack_queued = false
	
	# Schedule the lunge for frame 6
	await get_tree().create_timer(0.375).timeout
	# Calculate the direction toward the mouse position and set a lunge velocity
	var direction_to_mouse = (
		player.get_global_mouse_position() - player.global_position
		).normalized()
	player.velocity = direction_to_mouse * lunge_speed
	
	await get_tree().create_timer(0.1).timeout #Delays hit for peak swing
	attack_hurt_box.monitoring = true
	
	await get_tree().create_timer(combo_window_delay).timeout
	pass


# What happens when the player exits this State
func Exit() -> void:
	weapon_anims.animation_finished.disconnect(EndAttack)
	attacking = false
	attack_hurt_box.monitoring = false
	
	if player.current_vertical_direction == "up":
		weapon_sprite.z_index = 1
	else:
		weapon_sprite.z_index = 0

	pass


# What happens during the _process update in this State
func Process(_delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if attack_queued:
			return attack_2
		else:
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
	if _event.is_action_pressed("attack"):
		attack_queued = true
	return null


# Resets attacking to false once the attacking animation has finished
func EndAttack(_newAnimName : String) -> void:
	attacking = false
	weapon_holder.rotation = 0  # Reset to the default rotation after the attack
	if attack_queued:
		player.state_machine.ChangeState(attack_2)


# Update the weapon rotation based on mouse position
func update_weapon_rotation() -> void:
	var direction_to_mouse = (player.get_global_mouse_position() - player.global_position).normalized()

	# Adjust rotation based on player's facing direction
	if player_sprite.scale.x < 0:
		weapon_holder.rotation = -direction_to_mouse.angle() + PI
	else:
		weapon_holder.rotation = direction_to_mouse.angle()
