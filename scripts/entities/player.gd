class_name Player extends CharacterBody2D

# Variables
var cardinal_direction : Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var move_speed: float = 60
var state : String = "idle"

@onready var anim : AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	pass

func _process(_delta):
	# Handles player input and updates direction for movement
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	velocity = direction * move_speed
	
	# Updates animation if either state or direction has changed
	if SetState() == true || SetDirection() == true:
		UpdateAnim()

func _physics_process(delta):
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

# Determines if the state should change based on player movement
func SetState() -> bool:
	var new_state : String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	state = new_state
	return true

# Updates the animation based on the current state and facing direction
func UpdateAnim() -> void:
	anim.play(state + "_" + AnimDirection())

# Determines the animation direction string based on the cardinal direction
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.LEFT:
		return "left"
	else:
		return "right"
