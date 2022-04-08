extends State


func enter(msg := {}) -> void:
	print('FALL')
	pass


func physics_update(delta: float) -> void:
	
	
	
	# Capture the direcion of the input
	var dir : Vector2 = owner.directional_input()
	
	
	# checks if we need to change the state
	if owner.is_on_floor():
		if dir.x == 0:
			state_machine.transition_to('Idle')
		else:
			state_machine.transition_to('Run')
		return
	
	
	# checks if the owner is accelerating or decelerating
	if not dir.x == 0:
		owner.velocity.x = lerp(owner.velocity.x, dir.x * owner.speed, owner.acceleration)
	else:
		owner.velocity.x = lerp(owner.velocity.x, 0, owner.friction)
	
	
	# moves the owner in the air
	owner._move_and_slide(delta)
	
	
	# Capture the movement
	var movement : String = owner.movement_input()
	
	# Checks if the movement recieved is prohibited
	if not movement == '' and not prohibited.has(movement):
		var msg := {}
		if movement == 'Dash':
			msg['direction'] = dir
		state_machine.transition_to(movement, msg)






























