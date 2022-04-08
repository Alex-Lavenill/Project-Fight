extends KinematicBody2D

# Declaring class
class_name Character


# Exports
export (String) var char_name
export (int, 0, 10) var defense
export (int, 0, 100, 5) var strength
export (int) var speed = 300
export (int) var gravity = 3000
export (float, 0, 1.0) var friction = 0.2
export (float, 0, 1.0) var acceleration = 0.15

# Common Attacks
var light_attacks := {
	['u', 'l'] : "UpLight",
	['s', 'l'] : "SideLight",
	['d', 'l'] : "DownLight"
}
var heavy_attacks := {
	['u', 'h'] : "UpHeavy",
	['s', 'h'] : "SideHeavy",
	['d', 'h'] : "DownHeavy",
}

# Unique Skills
var skills: Dictionary

# Booleans
var can_dash := true
var can_jump := true
var is_dashing := false

# Integers
var curr_direction := 1

# Vectors
var direction := Vector2.ZERO
var velocity := Vector2.ZERO


# Moves the character at its current velocity
func _move_and_slide(delta: float) -> void:
	
	# Check if the character is grounded
	if is_on_floor():
		can_jump = true
	
	
	# Apply gravity in the body, except when its dashing
	if not is_dashing:
		velocity.y += gravity * delta
	
	
	velocity = move_and_slide(velocity, Vector2.UP)



