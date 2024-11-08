class_name State_Idle extends State


@onready var walk: State = $"../Walk"
@onready var attack: State = $"../Attack"
@onready var dodge: State = $"../Dodge"
@onready var weapon_anim: AnimationPlayer = $"../../Player/Weapons/WeaponAnims"


# What happens when the player enters this State
func Enter() -> void:
	pass


# What happens when the player exits this State
func Exit() -> void:
	pass


# What happens during the _process update in this State
func Process(_delta : float) -> State:
	player.UpdateAnim("idle")
	#weapon_anim.play("1h_sword_idle_" + player.AnimDirection())
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null 


# What happens during the _physics_process update in this State
func Physics(_delta : float) -> State:
	return null


# What happens with input events in this State
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	elif _event.is_action_pressed("dodge_roll"):
		return dodge
	return null
