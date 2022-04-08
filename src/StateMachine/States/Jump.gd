extends State


# Exports
export (float) var impulse := 900


func enter(msg := {}) -> void:
	print('JUMP')
	if not owner.is_on_floor():
		owner.can_jump = false
	print(owner.can_jump)


func physics_update(delta: float) -> void:
	
	
	# adds the jump impulse
	owner.velocity.y = -impulse
	
	
	# Capture the direcion of the input
	var dir : Vector2 = owner.directional_input()
	
	
	# Moves the owner in the velocity and set to the falling state
	owner.velocity.x = lerp(owner.velocity.x, dir.x * owner.speed, owner.acceleration)
	owner._move_and_slide(delta)
	state_machine.transition_to("Fall")




