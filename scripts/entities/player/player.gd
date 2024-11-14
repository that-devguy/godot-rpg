class_name Player extends CharacterBody2D


# Variables
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var current_vertical_direction : String = "down"
var flip : float = 1

@onready var anim: AnimationPlayer = $Player/PlayerAnims
@onready var player_sprite: Sprite2D = $Player
@onready var weapon_sprite: Sprite2D = $Player/Weapon
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
	
	# Handle horizontal movement (left/right)
	if direction.x < 0:
		new_dir = Vector2.LEFT
		player_sprite.scale.x = -1  # Flip to left
	elif direction.x > 0:
		new_dir = Vector2.RIGHT
		player_sprite.scale.x = 1  # Flip to right
	
	# Handle vertical movement (up/down)
	if direction.y < 0:
		new_dir = Vector2.UP
		current_vertical_direction = "up"  # Update to up animation
		weapon_sprite.z_index = 1
	elif direction.y > 0:
		new_dir = Vector2.DOWN
		current_vertical_direction = "down"  # Update to down animation
		weapon_sprite.z_index = 0
	
	# If direction has changed, update cardinal direction
	if new_dir != cardinal_direction:
		cardinal_direction = new_dir
		return true
	
	return false


# Updates the animation based on the current state and facing direction
func UpdateAnim(state: String) -> void:
	anim.play(state + "_" + AnimDirection())
	pass


# Determines the animation direction string based on vertical direction (up/down) and flip for horizontal
func AnimDirection() -> String:
	return current_vertical_direction
