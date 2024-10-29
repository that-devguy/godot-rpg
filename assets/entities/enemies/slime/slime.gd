extends CharacterBody2D

# Variables
@export var speed = 40
var player_chase = false
var player = null
var is_attacking = false
var current_dir = ""

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk_down")
	else:
		$AnimatedSprite2D.play("idle_down")

func _on_detection_zone_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_zone_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
