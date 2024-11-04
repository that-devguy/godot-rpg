class_name Player extends CharacterBody2D


# Variables
var cardinal_direction : Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine

func _ready():
	state_machine.Initialize(self)


func _process(_delta: float) -> void:
	# Handles player input and updates direction for movement
	direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()


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
	anim.play(state + "_" + AnimDirection())


# Determines the animation direction string based on the mouse position
func AnimDirection() -> String:
	var mouse_position = get_global_mouse_position()
	var direction_to_mouse = (mouse_position - global_position).normalized()

	if abs(direction_to_mouse.x) > abs(direction_to_mouse.y):
		if direction_to_mouse.x > 0:
			return "right"
		else:
			return "left"
	else:
		if direction_to_mouse.y > 0:
			return "down"
		else:
			return "up"
