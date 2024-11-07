class_name EnemyStateDestroy extends EnemyState


@export var anim_name : String = "destroy"
@export var knockback_speed : float = 100.0
@export var descelerate_speed : float = 10.0
@onready var shadow: Sprite2D = $"../../Shadow"

@export_category("AI")

var _damage_position : Vector2
var _direction : Vector2
var _timer : float = 0.3


# What happens when we initialize this State
func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	pass 


# What happens when the player enters this State
func Enter() -> void:
	enemy.invulnerable = true
	
	_direction = enemy.global_position.direction_to(_damage_position)
	
	enemy.set_direction(_direction)
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_anim(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	
	pass


# What happens when the player exits this State
func Exit() -> void:
	pass


# What happens during the _process update in this State
func Process(_delta : float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		ToggleShadow()
	enemy.velocity -= enemy.velocity * descelerate_speed * _delta
	return null 


# What happens during the _physics_process update in this State
func Physics(_delta : float) -> EnemyState:
	return null


func _on_enemy_destroyed(hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.ChangeState(self)


func _on_animation_finished(_a : String) -> void:
	enemy.queue_free()


func ToggleShadow() -> void:
	shadow.visible = false
