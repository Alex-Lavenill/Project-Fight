extends State


# Functions


func enter(msg := {}) -> void:
	print('FALL')


func physics_update(delta: float) -> void:
	
	
	# Capture the direcion of the input
	var dir : Vector2 = owner.directional_input()
	
	# checks if we need to change the state
	var movement : String = owner.movement_input()
	
	
	# Checks if the movement recieved is prohibited
	if not movement == '' and not prohibited.has(movement):
		var msg := {}
		
		match (movement):
			'Dash':
				msg['direction'] = dir
			'Fall-Through':
				msg['from_the_air'] = true
		
		state_machine.transition_to(movement, msg)
		return
	
	
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
	print('caindo ', dir)
	
	
	# moves the owner in the air
	owner._move_and_slide(delta)
	
	






























