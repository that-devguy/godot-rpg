class_name State_Dodge extends State


@export var move_speed : float = 60.0
@export var dodge_duration : float = 0.45

@onready var idle: State = $"../Idle"
@onready var walk: State_Walk = $"../Walk"

var dodging : bool = false
var _timer : float = 0.0


# What happens when the player enters this State
func Enter() -> void:
	var dodge_direction = ""
	
	# Determines dodge direction based on input vector (Joystick friendly)
	if abs(player.direction.x) > abs(player.direction.y):
		dodge_direction = "dodge_left" if player.direction.x < 0 else "dodge_right"
	else:
		dodge_direction = "dodge_up" if player.direction.y < 0 else "dodge_down"
	
	dodging = true
	_timer = dodge_duration
	player.velocity = player.direction * move_speed
	player.anim.play(dodge_direction)
	pass


# What happens when the player exits this State
func Exit() -> void:
	dodging = false
	player.velocity = Vector2.ZERO
	pass


# What happens during the _process update in this State
func Process(_delta : float) -> State:
	_timer -= _delta
	if _timer <= 0:
		return idle
	
	player.velocity = player.direction * move_speed
	return null


# What happens during the _physics_process update in this State
func Physics(_delta : float) -> State:
	player.move_and_slide()
	return null
