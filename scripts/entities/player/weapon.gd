class_name Weapon extends Sprite2D

@export var swing_duration: float = 0.1  # Duration for each swing phase
@export var max_swing_angle: float = 120  # Max swing angle in degrees

var is_swinging: bool = false  # Track if the weapon is currently swinging

# Performs a weapon swing
func swing_weapon(target_angle: float) -> void:
	if is_swinging:
		return  # Prevent overlapping swings

	is_swinging = true
	var tween = create_tween()

	# Set the initial angle for the swing
	rotation = target_angle

	# First swing phase: Rotate to the max swing angle (counter-clockwise)
	tween.tween_property(self, "rotation", target_angle - deg_to_rad(max_swing_angle), swing_duration).set_trans(Tween.TRANS_SINE)

	# Second swing phase: Rotate past the target angle (clockwise)
	tween.tween_property(self, "rotation", target_angle + deg_to_rad(max_swing_angle), swing_duration).set_trans(Tween.TRANS_SINE)

	# Final swing phase: Return to the resting position
	tween.tween_property(self, "rotation", target_angle, swing_duration).set_trans(Tween.TRANS_SINE)

	# Callback to reset `is_swinging` after the swing is complete
	tween.tween_callback(func(): is_swinging = false)
