class_name EnemyStateStun extends EnemyState


@export var anim_name : String = "stun"
@export var small_knockback_speed : float = 20.0
@export var large_knockback_speed : float = 100.0
@export var descelerate_speed : float = 10.0

@export_category("AI")
@export var next_state : EnemyState

var _damage_position : Vector2
var _direction : Vector2
var _animation_finished : bool = false
var knockback_speed : float = small_knockback_speed


# What happens when we initialize this State
func init() -> void:
	enemy.enemy_damaged.connect(_on_enemy_damaged)
	pass 


# What happens when the player enters this State
func Enter() -> void:
	enemy.invulnerable = true
	_animation_finished = false
	
	_direction = enemy.global_position.direction_to(_damage_position)
	
	enemy.set_direction(_direction)
	
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_anim(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	pass


# What happens when the player exits this State
func Exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	knockback_speed = small_knockback_speed
	pass


# What happens during the _process update in this State
func Process(_delta : float) -> EnemyState:
	if _animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * descelerate_speed * _delta
	return null 


# What happens during the _physics_process update in this State
func Physics(_delta : float) -> EnemyState:
	return null


func _on_enemy_damaged(hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	if hurt_box.source_state is State_Attack3:
		knockback_speed = large_knockback_speed
	else:
		knockback_speed = small_knockback_speed
	
	state_machine.ChangeState(self)


func _on_animation_finished(_a : String) -> void:
	_animation_finished = true
	knockback_speed = small_knockback_speed
