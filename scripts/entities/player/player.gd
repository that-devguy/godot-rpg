class_name Player extends CharacterBody2D


var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var current_vertical_direction : String = "down"
var flip : float = 1
var is_attacking : bool = false

@onready var anim: AnimationPlayer = $Player/PlayerAnims
@onready var player_sprite: Sprite2D = $Player
@onready var weapon_sprite: Sprite2D = $Player/WeaponHolder/Weapon
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
	if is_attacking:
		return false #Skip direction updates during an attack
	
	var new_dir: Vector2 = cardinal_direction

	if direction == Vector2.ZERO:
		return false
	
	# Handle horizontal movement (left/right)
	if direction.x < 0:  # Moving left
		player_sprite.scale.x = -1  # Flip to left
	elif direction.x > 0:  # Moving right
		player_sprite.scale.x = 1  # Flip to right

	# Handle vertical movement (up/down)
	if direction.y < 0:  # Moving up
		current_vertical_direction = "up"
		new_dir = Vector2.UP
	elif direction.y > 0 or (direction.x != 0):  # Moving down or horizontal
		current_vertical_direction = "down"
		new_dir = Vector2.DOWN

	# Update the weapon z-index based on vertical movement
	if current_vertical_direction == "up":
		weapon_sprite.z_index = 1  # Weapon above player
	else:
		weapon_sprite.z_index = 0  # Weapon below player

	# If direction has changed, update cardinal direction
	if new_dir != cardinal_direction:
		cardinal_direction = new_dir
		return true
		
	return false


# Updates the animation based on the current state and facing direction
func UpdateAnim(state: String) -> void:
	anim.play(state + "_" + AnimDirection())
	pass


# Determines the animation direction string based on the last significant input
func AnimDirection() -> String:
	# Use the last vertical direction to decide animation
	if current_vertical_direction == "up":
		return "up"
	else:
		return "down"


func GetAttackAnimDirection() -> String:
	is_attacking = true
	
	var direction_to_mouse = (get_global_mouse_position() - global_position).normalized()
	
	# Calculate the angle between player and mouse in degrees
	var angle_to_mouse = direction_to_mouse.angle() * 180 / PI  # Convert to degrees
	
	# Normalize the angle to 0-360 range
	if angle_to_mouse < 0:
		angle_to_mouse += 360
	
	# Determine the animation direction based on the angle
	if angle_to_mouse >= 340 or angle_to_mouse < 90:  # Down-right
		player_sprite.scale.x = 1
		current_vertical_direction = "down"  # Update player's vertical direction
		return "down"
	elif angle_to_mouse >= 90 and angle_to_mouse < 200:  # Down-left
		player_sprite.scale.x = -1
		current_vertical_direction = "down"  # Update player's vertical direction
		return "down"
	elif angle_to_mouse >= 200 and angle_to_mouse < 270:  # Up-left
		player_sprite.scale.x = -1
		current_vertical_direction = "up"  # Update player's vertical direction
		return "up"
	else:  # Up-right
		player_sprite.scale.x = 1
		current_vertical_direction = "up"  # Update player's vertical direction
		return "up"


func _on_player_anims_animation_finished(_anim_name: StringName) -> void:
	is_attacking = false
	pass
