class_name State_Attack2 extends State


@export_range(1,20,0.5) var decelerate_speed : float = 5.0
@export var lunge_speed : float = 100
@export var combo_window_delay: float = 0.01 # Time before the combo can be initialized
@export var attack_3: State 

@onready var attack_hurt_box: HurtBox = %AttackHurtBox
@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"

var attacking : bool = false
var attack_queued: bool = false


# What happens when the player enters this State
func Enter() -> void:
	player.UpdateAnim("sword_attack2")
	player.anim.animation_finished.connect(EndAttack)
	attack_hurt_box.source_state = self
	attacking = true
	attack_queued = false
	
	# Calculate the direction toward the mouse position and set a lunge velocity
	#var direction_to_mouse = (
		#player.get_global_mouse_position() - player.global_position
		#).normalized()
	#player.velocity = direction_to_mouse * lunge_speed
	
	
	await get_tree().create_timer(0.15).timeout #Delays hit for peak swing
	attack_hurt_box.monitoring = true
	
	await get_tree().create_timer(combo_window_delay).timeout
	pass


# What happens when the player exits this State
func Exit() -> void:
	player.anim.animation_finished.disconnect(EndAttack)
	attacking = false
	attack_hurt_box.monitoring = false
	pass


# What happens during the _process update in this State
func Process(_delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if attack_queued:
			return attack_3
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
	if attack_queued:
		player.state_machine.ChangeState(attack_3)
