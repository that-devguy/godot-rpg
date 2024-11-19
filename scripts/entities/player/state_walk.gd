class_name State_Walk extends State


@export var move_speed : float = 60.0
@export var attack_1 : State

@onready var idle : State = $"../Idle"
@onready var dodge : State = $"../Dodge"
@onready var footstep_audio : AudioStreamPlayer2D = $"../../FootstepsAudio"

var footstep_timer : float = 0.0
var footstep_interval : float = 0.25

# What happens when the player enters this State
func Enter() -> void:
	footstep_timer = 0.0
	if not footstep_audio.is_playing():
		footstep_audio.play()
	pass


# What happens when the player exits this State
func Exit() -> void:
	footstep_audio.stop()
	pass


# What happens during the _process update in this State
func Process(_delta : float) -> State:
	player.UpdateAnim("walk")
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	# Handle footstep sounds
	footstep_timer += _delta
	if footstep_timer >= footstep_interval:
		if footstep_audio.is_playing():
			footstep_audio.stop()  # Restart sound if already playing
		footstep_audio.pitch_scale = randf_range(0.8, 1.2)
		footstep_audio.play()
		footstep_timer = 0.0
	
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
