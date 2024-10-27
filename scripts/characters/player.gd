extends CharacterBody2D

# Variables
@export var speed = 60
var is_attacking = false
var current_dir = ""

func _ready():
	# Sets the initial idle animation when the scene loads
	$AnimatedSprite2D.play("idle_down")

func _physics_process(delta):
	player_movement(delta)

# Handles player movement and direction
func player_movement(delta):
	if Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	else:
		play_anim(0)
		velocity.y = 0
		velocity.x = 0
	
	move_and_slide()

# Handles player anims based on movement and direction
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D

	if dir == "up":
		if movement == 1:
			anim.play("walk_up")
		elif movement == 0:
			anim.play("idle_up")
	if dir == "down":
		if movement == 1:
			anim.play("walk_down")
		elif movement == 0:
			anim.play("idle_down")
	if dir == "left":
		if movement == 1:
			anim.play("walk_left")
		elif movement == 0:
			anim.play("idle_left")
	if dir == "right":
		if movement == 1:
			anim.play("walk_right")
		elif movement == 0:
			anim.play("idle_right")
