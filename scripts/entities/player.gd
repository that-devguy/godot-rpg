extends "res://scripts/entities/entity_base.gd"

# Variables
var is_attacking = false
var current_dir = ""
var is_dead = false

func _ready():
	$AnimatedSprite2D.play("idle_down")

func _physics_process(_delta):
	if not is_dead:  # Prevent player movement if dead
		player_movement(_delta)

# Handles player movement and direction
func player_movement(_delta):
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

# Handles player animations based on movement and direction
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

func _on_hp_changed():
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "up":
		anim.play("damage_up")
	if dir == "down":
		anim.play("damage_down")
	if dir == "left":
		anim.play("damage_left")
	if dir == "right":
		anim.play("damage_right")

func _on_died():
	if not is_dead:  # Prevent multiple triggers
		is_dead = true
		$AnimatedSprite2D.play("death")
		velocity = Vector2.ZERO
		print("you died")

func _on_animation_finished(anim_name):
	if anim_name == "death":
		# Handle what happens after death animation
		queue_free()
