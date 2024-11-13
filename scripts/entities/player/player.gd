class_name Player extends CharacterBody2D


# Variables
var cardinal_direction : Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var dir: String = "down"
var flip_state : bool = false

@onready var anim: AnimationPlayer = $Player/PlayerAnims
@onready var sprite: Sprite2D = $Player
@onready var state_machine : PlayerStateMachine = $StateMachine


func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	pass


func _process(_delta: float) -> void:
	# Handles player input and updates direction for movement
	direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	
	SetDirection()
	
	pass


func _physics_process(_delta: float) -> void:
	move_and_slide()


# Checks if the direction has changed and updates the cardinal direction if needed
func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	
	# Determines new direction based on input vector (Joystick friendly)
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	return true


# Updates the animation based on the current state and facing direction
func UpdateAnim(state: String) -> void:
	var anim_direction = AnimDirection()
	anim.play(state + "_" + anim_direction["direction"])
	
	sprite.flip_h = anim_direction["flip"]


# Determines the animation direction string based on the mouse position
func AnimDirection() -> Dictionary:
	if cardinal_direction == Vector2.DOWN:
		dir = "down"
	elif cardinal_direction == Vector2.UP:
		dir = "up"
	
	# If direction.x is negative, set flip_state to true (left movement)
	if direction.x < 0 and !flip_state:
		flip_state = true
	# If direction.x is positive, set flip_state to false (right movement)
	elif direction.x > 0 and flip_state:
		flip_state = false
	
	return {"direction": dir, "flip": flip_state}
