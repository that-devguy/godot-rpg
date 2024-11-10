class_name State_Walk extends State


@export var move_speed : float = 60.0
@export var attack_1: State

@onready var idle: State = $"../Idle"
@onready var dodge: State = $"../Dodge"


# What happens when the player enters this State
func Enter() -> void:
	pass


# What happens when the player exits this State
func Exit() -> void:
	pass


# What happens during the _process update in this State
func Process(_delta : float) -> State:
	player.UpdateAnim("walk")
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	return null


# What happens during the _physics_process update in this State
func Physics(_delta : float) -> State:
	return null


# What happens with input events in this State
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack_1
	elif _event.is_action_pressed("dodge_roll"):
		return dodge
	return null
